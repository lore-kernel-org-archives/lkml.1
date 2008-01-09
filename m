Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbYAIFEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbYAIFEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 00:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYAIFEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 00:04:22 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50177 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYAIFEV (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 00:04:21 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
In-Reply-To: Your message of "Tue, 08 Jan 2008 22:50:43 +0900."
             <200801082250.CJH13533.OFSMHFVOLtJQOF@I-love.SAKURA.ne.jp>
From: Valdis.Kletnieks@vt.edu
References: <200712232344.JBJ90661.FQOFtFOVLJHSOM@I-love.SAKURA.ne.jp> <20071231200247.GA30373@sergelap.austin.ibm.com> <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp> <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp> <6879.1199725780@turing-police.cc.vt.edu>
            <200801082250.CJH13533.OFSMHFVOLtJQOF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199855042_3703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Jan 2008 00:04:02 -0500
Message-ID: <10946.1199855042@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199855042_3703P
Content-Type: text/plain; charset=us-ascii

On Tue, 08 Jan 2008 22:50:43 +0900, Tetsuo Handa said:

> Yes. It is a line-by-line processable format defined as:
> 
>   filename permission owner group flags type [ symlink_data | major minor ]
> 
> where flags are bit-wised combinations of
> 
>   *  1: Allow creation of the file.
>   *  2: Allow deletion of the file.
>   *  4: Allow changing permissions of the file.
>   *  8: Allow changing owner or group of the file.
>   * 16: For internal use. Remembers whether this file is opened or not.
>   * 32: Don't create this file at mount time.
> 
> and here are some example entries:
> 
>   pts     755     0       0       0       d

Good summary - probably should add that to the patch, drop it into
Documentation/syaoran-config.txt or similar...

> > the idea of passing a file to be read by the kernel, but I also understand
> > that if it isn't done before mount, you have a race condition betweet the
> > mount and the load.
> What race condition is possible?
> Are you worrying that the file gets modified while reading?

Modification while reading *is* an issue, but can probably be worked around
with some clever locking.  The race condition I was thinking of was if you
had the mount and the policy load be 2 separate events, you could see:

(a) issue mount request
                        (b) do something malicious in /dev while..
(c) load the policy that would have prevented (b).

This is partly why SELinux has init load the policy *very* early on, before
any other userspace have had a chance to run and do things that would have
been prevented by policy.  

>> Does this do what you think it does if run in a chroot process or if
>> some creative person does "accept=../../path/to/bad_data.cfg"?
> sys_open() calls open_pathname() with AT_FDCWD.
> So, it is the same thing as calling
> open("../../path/to/bad_data.cfg", O_RDONLY) from the userland.

Which basically ends up meaning that anybody who can trick the mount into
happening can reset the permitted list and create (for example) a mode 666
entry for a hard drive, and go scribbling around at will.  Note that you
don't seem to do any sanity checking on the path (for instance, that each
component is owned by root, and not world-writable) - so anybody who finds
a way to get the mount to happen can supply their own list in /home/joeuser/blat
or /tmp/surprise-mount-list  or wherever.

>> That printk should be KERN_ERR, I think.
> May be. But I think KERN_WARNING is enough because this is not such emergent error.

OK, I can live with WARNING.  You just want to be sure it's above INFO...

--==_Exmh_1199855042_3703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHhFXCcC3lWbTT17ARAq3MAKDnUCsg6PUH3TsVepVh7hkTPlfCegCg/ERF
De1ZxrpxyB2uh4lMUymwINs=
=KF+f
-----END PGP SIGNATURE-----

--==_Exmh_1199855042_3703P--
