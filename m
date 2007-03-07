Return-Path: <linux-kernel-owner+w=401wt.eu-S965478AbXCGSde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965478AbXCGSde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965462AbXCGSde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:33:34 -0500
Received: from master.altlinux.org ([62.118.250.235]:4203 "EHLO
	master.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965486AbXCGSdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:33:33 -0500
X-Greylist: delayed 1409 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 13:33:32 EST
Date: Wed, 7 Mar 2007 21:09:03 +0300
From: Sergey Vlasov <vsu@altlinux.ru>
To: "Luong Ngo" <luong.ngo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Sleeping thread not receive signal until it wakes up
Message-Id: <20070307210903.0988be8f.vsu@altlinux.ru>
In-Reply-To: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com>
References: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.10.6; x86_64-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Mar_2007_21_09_03_+0300_cQioILeHWtxLr55T"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Mar_2007_21_09_03_+0300_cQioILeHWtxLr55T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 6 Mar 2007 21:31:37 -0800 Luong Ngo wrote:

> I am having this problem. I have a process with 2 threads created. One
> of the thread will keep calling IOCTL  to get information from the
> kernel and will be blocked if there is no new information. If there is
> information retured, the thread will be checked to see if any error
> happens and trigger an action. Since we have no way to know if the
> error is gone (Hardware provides no signal), so what we do is when
> trigger an action for the error, we will set an timer using alarm()
> and register a SIGALRM handler in the thread by using sigaction. After
> setting the alarm, the thread will loop back and call IOCTL, which
> could cause it to be put to sleep. The problem is the SIGALRM handler
> does not receive the SIGALRM while the thread is being blocked by
> IOCTL. And if we generated some event so that the IOCTL is returned
> with new information, the SIGALRM handler is invoked right away.
> However, as I read the manual, which says a thread/process should be
> waken up even when it sleeps if there is a signal delivered to it. Am
> I right?

Probably the ioctl handler of the driver you are calling does not use
interruptible sleeps, therefore it cannot be interrupted by a signal.
In this case you need to fix the driver to use interruptible sleeps
and return -ERESTARTSYS when some signal is pending.

--Signature=_Wed__7_Mar_2007_21_09_03_+0300_cQioILeHWtxLr55T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQFF7v/CW82GfkQfsqIRAlbNAJsFnV/wYAtsTripQBExSKqc2V8mYQCePhnK
6NrfCvGQdcaR5aMVr1KfkIs=
=ywnz
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Mar_2007_21_09_03_+0300_cQioILeHWtxLr55T--
