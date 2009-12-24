Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZLXMiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZLXMiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZLXMiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:38:05 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35232 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbZLXMiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:38:00 -0500
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/3] Security: Add prctl(PR_{GET,SET}_NETWORK)
References: <20091224061322.GB24396@heat>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 24 Dec 2009 04:37:41 -0800
In-Reply-To: <20091224061322.GB24396@heat> (Michael Stone's message of "Thu\, 24 Dec 2009 01\:13\:23 -0500")
Message-ID: <m1r5qkim3u.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stone <michael@laptop.org> writes:

>> Eric Biederman writes:
>>> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>>>> Michael Stone writes:
>>>>> the LSM-based version *does not* resolve the situation to my satisfaction as a
>>>>> userland hacker due to the well-known and long-standing adoption and
>>>>> compositionality problems facing small LSMs. ;)
>>>>
>>>> For things like Fedora it's probably an "interesting idea, perhaps we
>>>> should do it using SELinux" sort of problem, but a config option for a
>>>> magic network prctl is also going to be hard to adopt without producing a
>>>> good use case - and avoiding that by dumping crap into everyones kernel
>>>> fast paths isn't a good idea either.
>>
>>If I understand the problem the goal is to disable access to ipc
>>mechanism that don't have the usual unix permissions.  To get
>>something that is usable for non-root processes, and to get something
>>that is widely deployed so you don't have to jump through hoops in
>>end user applications to use it.
>
> Eric,
>
> You understand correctly. Thank you for this cogent restatement.
>
>>We have widely deployed mechanisms that are what you want or nearly
>>what you want already in the form of the various namespaces built for
>>containers.
>
> It's true that your work is closer to what I want than anything else that I've
> seen so far...
>
>> I propose you introduce a permanent disable of executing suid applications. 
>
> I'm open to the idea but I don't understand the need that motivates it yet.
> Could you please explain further? (or point me to an existing explanation?)

With namespaces it is possible to masquarade as a trusted source,
of information to a suid program such as /etc/passwd or a NIS server.

A one-way removal of the ability to exec suid programs is generally
simple and handy like chroot, and removes the need for CAP_SYS_ADMIN
in most cases.

Plan 9 did not support suid executables and supported an unprivileged
equivalent of unshare(NEWNS).

I need the full unprivileged unshare of USERNS for my primary
uses today as I need to perform normally root only activities
like mounting loopback devices, and setting up networking. Your
uses of limiting of ipc do not appear to require that.

>>After which point it is another trivial patch to allow unsharing of
>>the network namespace if executing suid applications are disabled.
>
> How do you propose to address the problem with the Unix sockets?

Careful code review of the patch to allow talking between network
namespaces with unix domain sockets.  This is a feature that we
simply have not merged yet.  Semantically it is fine today. It is
simply no one has answered the question what other implications
could there be.  Now that I know of 2 or 3 compelling use
cases and most of the rest of the work done.  It seems time to
relax the restriction.

Eric
