Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYDVF30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYDVF30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 01:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYDVF3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 01:29:18 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:37174 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYDVF3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 01:29:17 -0400
Message-ID: <480D77AC.7080202@kernel.org>
Date: Mon, 21 Apr 2008 22:29:16 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: serge@hallyn.com, David <david@unsolicited.net>
CC: casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
References: <46016.36939.qm@web36608.mail.mud.yahoo.com> <480B7D72.7020503@unsolicited.net> <20080421000055.GA17510@vino.hallyn.com> <20080421080101.htzh4s03snescog4@unsolicited.net> <20080421183451.GA22071@vino.hallyn.com> <480CE167.8090907@unsolicited.net> <20080421190143.GA23365@vino.hallyn.com> <480CF8DB.9010405@unsolicited.net> <20080422024259.GA27223@vino.hallyn.com>
In-Reply-To: <20080422024259.GA27223@vino.hallyn.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Short version:

As you have found, libcap2 does address your problem. I suspect that
libcap-1.97 here:

http://www.kernel.org/pub/linux/libs/security/linux-privs/libcap1/

will also prove successful. Please try it and report...

Thanks

Andrew

Long, and "almost funny" version:

A reason this fails on SUSE, is that SUSE appears to be shipping an
experimental version of libcap 1.92 (+ patches). That is I downloaded
the src.rpm from here:

http://download.opensuse.org/distribution/SL-10.1/inst-source/suse/src/

Did the "rpm2cpoi/cpio --extract" chicken dance and, much to my
surprise, discovered the package is based on an experimental version of
libcap that I had made (on a speculative libcap2 branch on sourceforge)
to work with some ancient (and experimental) filesystem capability
support (patches etc., captured here):

http://www.kernel.org/pub/linux/libs/security/linux-privs/old/kernel-2.2-fcap/README

This kernel patch was never integrated into the kernel, and Serge did
not go even remotely close to it for the final implementation of
filesystem capabilities in the kernel. Needless to say that this (old)
'experimental' libcap fails to work with the new 'released' kernel
support is not at all surprising! :-(

[FWIW The old experimental support extended the capset/capget system
call interface to manipulate filesystem capabilities, where Serge's
patch does this directly via extended attribute system calls. These two
access methods appear to be clashing quite horribly - but failing "safe".]

I believe code based on released version: libcap-1.10 and/or libcap-1.97
which you can download here:

http://www.kernel.org/pub/linux/libs/security/linux-privs/libcap1/

should work. You might like to try 1.97 as a replacement for the SUSE
version and report any issues (the SUSE guys may need to think about a
migration path).

serge@hallyn.com wrote:
| Quoting David (david@unsolicited.net):
|> serge@hallyn.com wrote:
|>> Quoting David (david@unsolicited.net):
|>>
|>>> serge@hallyn.com wrote:
|>>>
|>>>>> /lib/libcap.so.1 -> libcap.so.1.92
|>>>>>
|>>>>> I guess that's 1.92 (should be the version shipped with SuSE 9.1).
|>>>>>
|>>>> Ok, thanks, then it's definately not what I was thinking.
|>>>>
|>>>> (Will wait to check out your strace)
|>>>>
|>>> strace attached.
|>>>
|>>> Cheers
|>>> David
|>>>
|>>>
|>> ...
|>>
|>>> capget(0x20071026, 0, {, , })           = -1 EINVAL (Invalid argument)
|>>>
|>> This is odd.  libcap-1.x should be passing in 0x19980330.
|>>
|>> Next, given the -EINVAL return value ntpd should be seeing a NULL result
|>> from cap_get_proc() and exiting right there.
|>>
|>> What version of ntpd is this?  (I must be looking at a wrong value, but
|>> even so the fact that cap_get_proc()->capget() is using 0x20071026 for
|>> version doesn't make sense)
|>>
|>>
|>>> capset(0, 0, {CAP_NET_BIND_SERVICE|CAP_SYS_TIME,
|>>> CAP_NET_BIND_SERVICE|CAP_SYS_TIME,
CAP_NET_BIND_SERVICE|CAP_SYS_TIME}) =
|>>> -1 EINVAL (Invalid argument)
|>>> time(NULL)                              = 1208803493
|>>> write(5, "21 Apr 19:44:53 ntpd[6118]: cap_"..., 92) = 92
|>>> munmap(0x40022000, 4096)                = 0
|>>> exit_group(-1)                          = ?
|>>> Process 6118 detached
|>>>
|>>
|> Oh dear .. more investigation... here's the source from libcap-1.92.
|> capget() is being called with null arguments, which I guess returns with
|> the latest version in ch.version ?
|>
|> The switch then fails and the set gets called with version = 0 ??
|>
|> Cheers
|> David
|>
|> void _libcap_establish_api(void)
|> {
|>    struct __user_cap_header_struct ch;
|>    struct __user_cap_data_struct cs;
|>
|>    if (_libcap_kernel_version) {
|>        _cap_debug("already identified kernal api 0x%.8x",
|>                   _libcap_kernel_version);
|>        return;
|>    }
|>
|>    memset(&ch, 0, sizeof(ch));
|>    memset(&cs, 0, sizeof(cs));
|>
|>    (void) capget(&ch, &cs);
|>
|>    switch (ch.version) {
|>
|>    case 0x19980330:
|>        _libcap_kernel_version = 0x19980330;
|>        _libcap_kernel_features = CAP_FEATURE_PROC;
|>        break;
|>
|>    case 0x19990414:
|>        _libcap_kernel_version = 0x19990414;
|>        _libcap_kernel_features = CAP_FEATURE_PROC|CAP_FEATURE_FILE;
|>        break;
|>
|>    default:
|>        _libcap_kernel_version = 0x00000000;
|>        _libcap_kernel_features = 0x00000000;
|>    }
|>
|>    _cap_debug("version: %x, features: %x\n",
|>               _libcap_kernel_version, _libcap_kernel_features);
|> }
|
| Interesting.  The version I was looking at (1.10) has nothing like this.
|
| I don't know what shipped with recent RedHat and Fedora distros, but I
| guess based on this we can in fact expect more failures from at least
| SuSe distros.
|
| We can't reasonably have newer kernels reply to a query with an older
| libcap version, so I don't know what to do here.  Andrew, do you have
| any ideas?
|
| thanks,
| -serge
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFIDXes+bHCR3gb8jsRAt/MAKCOJ3FA9ubvcxY/T69J1Lx4efwpwgCeJI/2
g19NRIbvrZKueObVZYngd04=
=iV8y
-----END PGP SIGNATURE-----
