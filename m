Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZLMNmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZLMNmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZLMNmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:42:31 -0500
Received: from lists.laptop.org ([18.85.2.145]:36993 "HELO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753353AbZLMNma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:42:30 -0500
Date: Sun, 13 Dec 2009 08:44:25 -0500
From: Michael Stone <michael@laptop.org>
To: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>
Subject: Re: Network isolation with RLIMIT_NETWORK, cont'd.
Message-ID: <20091213134425.GA4777@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
In-Reply-To: <200912131032.24251.remi@remlab.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rémi,                                                                                                                                                                                                                                                               
> You explicitly mention the need to connect to the X server over local sockets.
> But won't that allow the sandboxed application to send synthetic events to any
> other X11 applications? 

X11 cookie authentication and socket ownership+permissions effectively control
access to the X server by local processes. Thus, as an isolation author, I may
easily grant my isolated process any of:

   a) full access to the main X server 
   b) some access to a nested X server (like a Xephyr) which I'm using to do
      some event filtering
   c) no access to any X server by witholding thec cookies or by changing the
      permissions on the X socket to be more restrictive

with existing techniques.

> Hence unless the whole X server has restricted network access, this seems a
> bit broken? 

Not broken for the reasons I mentioned above. However, using this rlimit to
disable fresh network access for the whole X server actually sounds like a
rather nice idea; thanks for suggesting it.

> D-Bus, which also uses local sockets, will exhibit similar issues, 

Absolutely. However, D-Bus, like X, already has strong authentication
mechanisms in place that permit me to use pre-existing Unix discretionary 
access control to limit what communication takes place. More specifically, I can 

   a) tell D-Bus to use a file-system socket and change the credentials on that
      socket

   b) use cookies to authenticate incoming connections

   c) explicitly tell D-Bus what users and groups may connect via configuration
      files

   d) explicitly tell D-Bus what users and groups may send and receive which
      messages via configuration files

> as will any unrestricted IPC mechanism in fact. I am not sure if restricting
> network access but not other file descriptors makes that much sense...? Then
> again, I'm not entirely clear what you are trying to solve.

Inadequately access-controlled IPC mechanisms are the specific problem that I
am trying to address. Fortunately, these mechanisms seem to be rare: the only
two that I know of are non-AF_UNIX sockets and ptrace(). All the other IPC
mechanisms that I have seen may be adequately restricted by changing file
permissions and ownership.

> If I had to sandbox something, I'd drop the process file limit to 0. 

That is a technique that is commonly used by many people in this space. It
works well for some limited use cases and, like SECCOMP, is too restrictive for
the kinds of general-purpose applications that I'm sandboxing.

If you're interested,

   http://cr.yp.to/unix/disablenetwork.html

lists several specific problems. To see more, just try dropping RLIMIT_NOFILE
to 0 before launching all your favorite apps. I'd be curious to hear how far
you get.

Regards,

Michael
