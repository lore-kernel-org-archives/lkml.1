Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbXKSPNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbXKSPNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXKSPNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:13:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbXKSPNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:13:33 -0500
Message-ID: <4741A7DD.1030407@redhat.com>
Date: Mon, 19 Nov 2007 07:12:29 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com> <20071119145224.31ee5242.dada1@cosmosbay.com>
In-Reply-To: <20071119145224.31ee5242.dada1@cosmosbay.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Dumazet wrote:
>>   union indirect_params i;
>>   i.file_flags.flags = O_CLOEXEC;
> 
> This setup forbids future addons to file_flags
> 
> In three years, when we want to add a new indirect feature to socket() 
> call, do we need a new indirect2() syscall ?

No, it doesn't.  The setup is indefinitely expandable.

All you need to do, if it becomes necessary to have more than an int, is
to define a little structure for the system call and then use it.  The
only requirement is that the code has to assume a value of zero is what
is used today.  That's the whole point.

union indirect_params {
  struct {
    int flags;
  } file_flags;
  struct {
    int flags;
    int new_syscall_data1;
    sigset_t and_a_sigmask;
  } new_data;
};

Old programs will set only the 'flags' member of 'new_data' while new
once can also set the new elements.  New programs on old kernels will
eithe have failing calls since the structure is too big or the call will
not have all the desired effects.  The latter can be tested for.


> Or better, you could avoid using 'union indirect_params' in user code, and 
> only use the substructs for each function.

There is no overhead introduced through the union.  The only reason the
union is there in the first place is to allocate sufficient data in
task_struct to cover all cases.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHQafd2ijCOnn/RHQRAlSFAJ99lahwCDZGRSlIHCov5bWowrpoiQCgwvW4
LDSEusNUpMfIE1ywBCRDBfc=
=ChVT
-----END PGP SIGNATURE-----
