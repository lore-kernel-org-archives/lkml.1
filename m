Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbZL0QW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbZL0QW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 11:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZL0QW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 11:22:56 -0500
Received: from lists.laptop.org ([18.85.2.145]:50988 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005AbZL0QWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 11:22:55 -0500
Date: Sun, 27 Dec 2009 11:25:03 -0500
From: Michael Stone <michael@laptop.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       Michael Stone <michael@laptop.org>
Subject: Re: [PATCH 3/3] Security: Document disablenetwork. (v4)
Message-ID: <20091227162502.GC12645@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <200912271039.DHG51586.FMFFHOJSLVQtOO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Michael Stone wrote:
>> +Exceptions are made for
>> +  * processes calling sendmsg() on a previously connected socket
>> +      (i.e. one with msg.msg_name == NULL && msg.msg_namelen == 0) or
> 
> What should we do for non connection oriented protocols (e.g. UDP)
> but destination is already configured by previous connect() request?
> 
> struct sockaddr_in addr = { ... };
> int fd2 = socket(PF_INET, SOCK_DGRAM, 0);
> connect(fd2, (struct sockadr *) &addr, sizeof(addr));
> prctl( ... );
> sendto(fd2, buffer, len, 0, NULL, 0); /* Should we allow this? */

This call should be allowed. man 2 send states that this call is equivalent to

   send(fd2, buffer, len, 0)

and, since the flags field is 0, to

   write(fd2, buffer, len)

which are both clearly permitted.

> sendto(fd2, buffer, len, 0, (struct sockadr *) &addr, sizeof(addr)); /* Should we reject this? */

It is reasonable to reject this call because it is not required to be
equivalent to a send() or write() call. 

(In fact, the current UDP implementation unconditionally uses the addr argument
passed to sendmsg in favor of the socket addr whenever it exists.)

However, it might also be reasonable to permit the send when the call would be
equivalent to a permitted send() or write() call: for example, when the socket
destination address exists and matches the message destination address.

Unfortunately, I don't think that we have an appropriate generic address
comparison function for deciding this equivalence. Am I mistaken?

Regards, and thanks for your questions,

Michael

P.S. - I would be happy to include a brief explanatory comment in the code
defining this test since this is by far the most complex test in the patch. Any
suggestions on what it might say?
