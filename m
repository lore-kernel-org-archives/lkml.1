Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbZJKBmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbZJKBmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 21:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZJKBmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 21:42:13 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:37396 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbZJKBmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 21:42:13 -0400
X-Greylist: delayed 705 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Oct 2009 21:42:12 EDT
From: Wolfgang Walter <wolfgang.walter@stwm.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
Date: Sun, 11 Oct 2009 03:29:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31.2; KDE/4.3.2; i686; ; )
Cc: Fred.L.Templin@boeing.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, contact@saschahlusiak.de,
       yoshfuji@linux-ipv6.org
References: <20091009233411.852013234@mini.kroah.org> <12F4112206976147A34FEC0277597CCF27A416492F@XCH-NW-15V.nw.nos.boeing.com> <20091009.204231.204042155.davem@davemloft.net>
In-Reply-To: <20091009.204231.204042155.davem@davemloft.net>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <200910110329.49637.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 October 2009, David Miller wrote:
> From: "Templin, Fred L" <Fred.L.Templin@boeing.com>
> Date: Fri, 9 Oct 2009 17:34:49 -0700
> 
> > Wait a moment - I remember now that this code came
> > from Yoshifuji, and I believe there was a reason for
> > the cmax+1. The application is expected to know this
> > and to post a large enough buffer.

But wouldn't this corrupt kernel memory?

It seems:

kp is never larger then

	sizeof(struct ip_tunnel_prl) * cmax

so kp[cmax] is of by one.

userspace can't allocate a large enough buffer as doesn't know the size of the 
prl.

If the comment is correct and non-root can call this function it could set
	a.addr = htonl(INADDR_ANY);
	a.datalen = sizeof(*kp);

=> cmax == 1
=> kp[1] would be written if prl has 2 or more entries.

So I think the patch is correct.

Probably it would even be better to check for

	c >= ca

as this even more obviously correct.

> > 
> > Can we put this on hold until I have had a chance to
> > check my e-mail archives and my local iproute changes
> > (will respond on monday)?
> 
> Sure, we can keep it out of -stable for now.
> 
> But it is in Linus's tree so if you find we shouldn't do this
> you'll need to send me a revert for net-2.6
> 
> Otherwise if it's good, you'll have to remind me to resubmit
> it to -stable.
> 

This function seems to be a bit strange:

1)

	if (!kp) {
		/* We don't try hard to allocate much memory for
		 * non-root users.
		 * For root users, retry allocating enough memory for
		 * the answer.
		 */
		kp = kcalloc(ca, sizeof(*kp), GFP_ATOMIC);
		if (!kp) {
			ret = -ENOMEM;
			goto out;

why ist ret set to -ENOMEM
it will be set to 0  here:

	out:
		read_unlock(&ipip6_lock);

		len = sizeof(*kp) * c;
		ret = 0;


Because c == 0 len will be 0, so only
	put_user(len, &a->datalen)

will be executed
I'm not sure what this means for put_user(len, &a->datalen) but probably it 
will succed. Therefor the return value is 0 in this case.


I think the

	ret = 0

should be removed as ret is initialized to 0 so it will be zero if not 
modifiied.

And either

	if (! ret) {
		len = sizeof(*kp) * c;
		if ((len && copy_to_user(a + 1, kp, len)) || put_user(len, &a->datalen))
			ret = -EFAULT;
	}

or

	len = sizeof(*kp) * c;
	if (len && (opy_to_user(a + 1, kp, len) || put_user(len, &a->datalen))
		ret = -EFAULT;




2) Then

	c = 0;
	for (prl = t->prl; prl; prl = prl->next) {


c is already 0 here, so this seems to be unecessary


3)  If the caller should know that the list is to large for the buffer he 
supplied by returning -EFAULT then cmax should be increased by one:

	cmax = kprl.datalen / sizeof(kprl) + 1;


But probably user space should initialise its buffer with 0 and assume that the 
list was to large if the last entry's addr  != 0.


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
