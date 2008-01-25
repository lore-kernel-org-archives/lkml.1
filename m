Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbYAYHqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbYAYHqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761281AbYAYHc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:32:58 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:49887 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761537AbYAYHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:32:56 -0500
Message-ID: <479990A1.3050103@kernel.org>
Date: Thu, 24 Jan 2008 23:32:49 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
CC: akpm@osdl.org, serue@us.ibm.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/3] exporting capability code/name pairs (try 2nd)
References: <47997122.3070504@ak.jp.nec.com>
In-Reply-To: <47997122.3070504@ak.jp.nec.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

KaiGai,

While this is cute :-), I guess I'm still not all that convinced that
this is needed.

libcap already had some (admittedly not quite working) support for
numeric values of capabilities not currently defined (which I believe is
now fixed in top of trunk):

# ./setcap 35=i ./setcap
# ./getcap ./setcap
./setcap = 35+i

Although, I obviously can't argue that this is as readable as your
approach, it does seem unlikely that the rate of addition of new
capabilities will be all that great, and you can recompile everything
capability related in user-space on a live system without a reboot.
Further, if anyone ever wants to translate the capabilities into another
language, it seems like user-space is a much better place for that than
in the kernel.

This patch also requires that /sys be mounted. How does that work for
code operating early in the boot process or in a chroot environment
(where an incapable uid=0 account being able to read/write /sys & /proc
files can do more than a little damage)?

None of this touches on the fact that most utility applications that
will support capabilities "the right way"(TM), will need the #define's
at compile time for each of the capabilities they require (so they can
pepper critical regions with cap_set_flag()/cap_set_proc() code.

When I mentioned this last time, you said you felt this feature was more
aimed at admin applications like {get,set,pam_}cap. This is fine, but
none of these admin applications 'use' capabilities, they just make them
available/visible for other utility applications to use - which gets us
back to my point; the utility apps can't use them (properly) without
having compiled-in support to use them appropriately, which requires the
#define's at compile time or an appropriate vintage of sys/capability.h
which comes with an appropriately modern version of libcap.  So,
practically speaking all the capabilities the applications on a system
should need should be present in the libcap on the system.

All that being said, the friendliness factor of this is somewhat
undeniable, and so I can see why folk might want it in the kernel
anyway. If so, would it possible to move this code into
security/capability.c and not in the main kernel per-se - protected with
a configuration option? If it does appear in the kernel, we'll obviously
add your libcap changes too. If it doesn't, then perhaps we can meet
your needs with a slight modification to your libcap patch to read the
capabilities from an optional /etc/XXX file - and make text visibility
of 'late breaking' capabilities something that the admin can tweak as
needed?

Cheers

Andrew

Kohei KaiGai wrote:
| We can apply this patch to kernel-2.6.24.
| It enables to export code/name pairs of capabilities
| at /sys/kernel/capability/, as follows:
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHmZCh+bHCR3gb8jsRArf8AJ0QK/c54cvOp7Uo3FksZL1OHM3SEQCfdQ02
kOkmExkYjcpdF4xs0hcgrTI=
=rZNg
-----END PGP SIGNATURE-----
