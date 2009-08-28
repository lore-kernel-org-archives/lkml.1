Return-Path: <linux-kernel-owner+w=401wt.eu-S1751244AbZH1NKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbZH1NKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZH1NKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:10:36 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:39300 "EHLO
	QMTA07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbZH1NKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:10:35 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Aug 2009 09:10:35 EDT
Message-ID: <4A97D5E8.8010906@byu.net>
Date: Fri, 28 Aug 2009 07:04:40 -0600
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Florian Weimer <fweimer@bfk.de>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org, bug-gnulib@gnu.org,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] open: introduce O_NOSTD
References: <4A9285FC.8000606@byu.net>	<1251202593-3676-1-git-send-email-ebb9@byu.net>	<alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com>	<4A968FF8.8050109@byu.net> <82k50puxx8.fsf@mid.bfk.de>	<4A97D16D.5060003@byu.net> <82ocq0p0ba.fsf@mid.bfk.de>
In-Reply-To: <82ocq0p0ba.fsf@mid.bfk.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

According to Florian Weimer on 8/28/2009 6:52 AM:
> * Eric Blake:
> 
>> Your version fails to clear the cloexec bit of the final fd if the
>> original caller didn't request O_CLOEXEC.
> 
> Okay, but you can fix that in a race-free manner (but I thought that
> this was implied by open_safer).

The current semantics of gnulib's open_safer is that the result is
guaranteed to be 3 or larger.  It would require an audit of all gnulib
clients of the open_safer method to see whether it also makes sense to
change the semantics of open_safer to also guarantee that fds start life
with the cloexec bit set.  But maybe that is a change worth making in
gnulib, with applications intending to give an fd to a child process being
required to explicitly clear the cloexec bit.

>> Also, your suggestion has a definite race in that you are calling
>> open() multiple times rather than cloning an existing fd after the
>> first open(), such that another process could alter which file is
>> visited between your first and last open().
> 
> Sure, but this is an unobservable differen.ce

It is absolutely observable - if the user passed O_CREAT|O_EXCL as part of
their flags, then the second open() will inappropriately fail.

- --
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Cygwin)
Comment: Public key at home.comcast.net/~ericblake/eblake.gpg
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqX1egACgkQ84KuGfSFAYDKWACeMM4spqCsmgVVwME9+C/1tdpU
g7wAnR9FetGPGr7acXLfLIVvzYZ7tpz3
=VjUY
-----END PGP SIGNATURE-----
