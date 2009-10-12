Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbZJMBga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbZJMBga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbZJMBga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:36:30 -0400
Received: from slb-smtpout-01.boeing.com ([130.76.64.48]:38202 "EHLO
	slb-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbZJMBg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:36:29 -0400
X-Greylist: delayed 5510 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 21:36:25 EDT
From: "Templin, Fred L" <Fred.L.Templin@boeing.com>
To: Wolfgang Walter <wolfgang.walter@stwm.de>,
       David Miller <davem@davemloft.net>
CC: "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "contact@saschahlusiak.de" <contact@saschahlusiak.de>,
       "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Date: Mon, 12 Oct 2009 16:58:14 -0700
Subject: RE: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
Thread-Topic: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
Thread-Index: AcpKElbcjnC7y+x8QGORlXj4SBsO4QBhTavg
Message-ID: <12F4112206976147A34FEC0277597CCF27A4164C26@XCH-NW-15V.nw.nos.boeing.com>
References: <20091009233411.852013234@mini.kroah.org>
 	<12F4112206976147A34FEC0277597CCF27A416492F@XCH-NW-15V.nw.nos.boeing.com>
 	<20091009.204231.204042155.davem@davemloft.net>
 <200910110329.49637.wolfgang.walter@stwm.de>
In-Reply-To: <200910110329.49637.wolfgang.walter@stwm.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
x-tm-as-product-ver: SMEX-8.0.0.1181-5.600.1016-16942.004
x-tm-as-result: No--75.179600-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang,

Thanks for your comments. As I wrote to David and Greg,
I tested the patch and it is indeed good. I'd really
rather not get into changing other code that has
already been tested at this time, however.

Regards - Fred
fred.l.templin@boeing.com

> -----Original Message-----
> From: Wolfgang Walter [mailto:wolfgang.walter@stwm.de]
> Sent: Saturday, October 10, 2009 6:30 PM
> To: David Miller
> Cc: Templin, Fred L; gregkh@suse.de; linux-kernel@vger.kernel.org; stable@kernel.org; stable-
> review@kernel.org; torvalds@linux-foundation.org; akpm@linux-foundation.org;
> alan@lxorguk.ukuu.org.uk; contact@saschahlusiak.de; yoshfuji@linux-ipv6.org
> Subject: Re: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
> 
> On Saturday 10 October 2009, David Miller wrote:
> > From: "Templin, Fred L" <Fred.L.Templin@boeing.com>
> > Date: Fri, 9 Oct 2009 17:34:49 -0700
> >
> > > Wait a moment - I remember now that this code came
> > > from Yoshifuji, and I believe there was a reason for
> > > the cmax+1. The application is expected to know this
> > > and to post a large enough buffer.
> 
> But wouldn't this corrupt kernel memory?
> 
> It seems:
> 
> kp is never larger then
> 
> 	sizeof(struct ip_tunnel_prl) * cmax
> 
> so kp[cmax] is of by one.
> 
> userspace can't allocate a large enough buffer as doesn't know the size of the
> prl.
> 
> If the comment is correct and non-root can call this function it could set
> 	a.addr = htonl(INADDR_ANY);
> 	a.datalen = sizeof(*kp);
> 
> => cmax == 1
> => kp[1] would be written if prl has 2 or more entries.
> 
> So I think the patch is correct.
> 
> Probably it would even be better to check for
> 
> 	c >= ca
> 
> as this even more obviously correct.
> 
> > >
> > > Can we put this on hold until I have had a chance to
> > > check my e-mail archives and my local iproute changes
> > > (will respond on monday)?
> >
> > Sure, we can keep it out of -stable for now.
> >
> > But it is in Linus's tree so if you find we shouldn't do this
> > you'll need to send me a revert for net-2.6
> >
> > Otherwise if it's good, you'll have to remind me to resubmit
> > it to -stable.
> >
> 
> This function seems to be a bit strange:
> 
> 1)
> 
> 	if (!kp) {
> 		/* We don't try hard to allocate much memory for
> 		 * non-root users.
> 		 * For root users, retry allocating enough memory for
> 		 * the answer.
> 		 */
> 		kp = kcalloc(ca, sizeof(*kp), GFP_ATOMIC);
> 		if (!kp) {
> 			ret = -ENOMEM;
> 			goto out;
> 
> why ist ret set to -ENOMEM
> it will be set to 0  here:
> 
> 	out:
> 		read_unlock(&ipip6_lock);
> 
> 		len = sizeof(*kp) * c;
> 		ret = 0;
> 
> 
> Because c == 0 len will be 0, so only
> 	put_user(len, &a->datalen)
> 
> will be executed
> I'm not sure what this means for put_user(len, &a->datalen) but probably it
> will succed. Therefor the return value is 0 in this case.
> 
> 
> I think the
> 
> 	ret = 0
> 
> should be removed as ret is initialized to 0 so it will be zero if not
> modifiied.
> 
> And either
> 
> 	if (! ret) {
> 		len = sizeof(*kp) * c;
> 		if ((len && copy_to_user(a + 1, kp, len)) || put_user(len, &a->datalen))
> 			ret = -EFAULT;
> 	}
> 
> or
> 
> 	len = sizeof(*kp) * c;
> 	if (len && (opy_to_user(a + 1, kp, len) || put_user(len, &a->datalen))
> 		ret = -EFAULT;
> 
> 
> 
> 
> 2) Then
> 
> 	c = 0;
> 	for (prl = t->prl; prl; prl = prl->next) {
> 
> 
> c is already 0 here, so this seems to be unecessary
> 
> 
> 3)  If the caller should know that the list is to large for the buffer he
> supplied by returning -EFAULT then cmax should be increased by one:
> 
> 	cmax = kprl.datalen / sizeof(kprl) + 1;
> 
> 
> But probably user space should initialise its buffer with 0 and assume that the
> list was to large if the last entry's addr  != 0.
> 
> 
> Regards,
> --
> Wolfgang Walter
> Studentenwerk München
> Anstalt des öffentlichen Rechts
