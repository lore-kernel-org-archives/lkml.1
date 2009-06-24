Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZFXXBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZFXXBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZFXXAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:00:55 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:36828 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZFXXAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=RXn9WjsH1mGQlGnTkwenCdd5jF7KCARnxXWKNKhjHJcE1pv7eyEIRJgGcDyehpCffI
         rY7ep/uD+pvUwijTpyfDmr1d4NPaOHESsr3eN1h7wibDehkgJv43MrTQZg4xu5zqqi4e
         wkAHbjIO98Ip2GN8xMvZT9eVXpkCwU0TQ8RHU=
MIME-Version: 1.0
Date: Thu, 25 Jun 2009 01:00:56 +0200
Message-ID: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
Subject: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not 
	mounted
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Content-Type: multipart/mixed; boundary=001636c5b5266f8c51046d201466
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c5b5266f8c51046d201466
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

In some circumstances running process needs to re-execute
its image.

Among other useful cases, it is _crucial_ for NOMMU arches.

They need it to perform daemonization. Classic sequence
of "fork, parent dies, child continues" can't be used
due to lack of fork on NOMMU, and instead we have to do
"vfork, child re-exec itself (with a flag to not daemonize)
and therefore unblocks parent, parent dies".

Another crucial use case on NOMMU is POSIX shell support.
Imagine a shell command of the form "func1 | func2 | func3".
This can be implemented on NOMMU by vforking thrice,
re-executing the shell in every child in the form
"<shell> -c 'body of funcN'", and letting parent wait and collect
exitcodes and such. As far as I can see, it's the only way
to implement it correctly on NOMMU.

The program may re-execute itself by name if it knows the name,
but we generally may be unsure about it. Binary may be renamed,
or even deleted while it is being run.

More elegant way is to execute /proc/self/exe.
This works just fine as long as /proc is mounted.

But it breaks if /proc isn't mounted, and this can happen in real-world
usage. For example, when shell invoked very early in initrd/initramfs.

With this patch, it is possible to execute /proc/self/exe
even if /proc is not mounted. In the below example,
./sh is a static shell binary:

# chroot . ./sh
/ # echo $0
./sh
/ # . /proc/self/exe
hush: /proc/self/exe: No such file or directory
/ # /proc/self/exe   <==========
/ # echo $0
/proc/self/exe
/ # exit
/ # exit
#

On an unpatched kernel, command marked with <=== would fail.

How patch does it: when execve syscall discovers that opening of binary
image fails, a small bit of code is added to special case "/proc/self/exe"
string. If binary name is *exactly* that string, and if error is ENOENT
or EACCES, then exec will still succeed, using current binary's image.

Please apply.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--001636c5b5266f8c51046d201466
Content-Type: text/x-patch; charset=US-ASCII; name="linux-2.6.30_proc_self_exe.patch"
Content-Disposition: attachment; filename="linux-2.6.30_proc_self_exe.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwcn987t0

ZGlmZiAtdXJwIC4uL2xpbnV4LTIuNi4zMC5vcmcvZnMvZXhlYy5jIGxpbnV4LTIuNi4zMC9mcy9l
eGVjLmMKLS0tIC4uL2xpbnV4LTIuNi4zMC5vcmcvZnMvZXhlYy5jCTIwMDktMDYtMTAgMDU6MDU6
MjcuMDAwMDAwMDAwICswMjAwCisrKyBsaW51eC0yLjYuMzAvZnMvZXhlYy5jCTIwMDktMDYtMjUg
MDA6MjA6MTMuMDAwMDAwMDAwICswMjAwCkBAIC02NTIsOSArNjUyLDI1IEBAIHN0cnVjdCBmaWxl
ICpvcGVuX2V4ZWMoY29uc3QgY2hhciAqbmFtZSkKIAlmaWxlID0gZG9fZmlscF9vcGVuKEFUX0ZE
Q1dELCBuYW1lLAogCQkJCU9fTEFSR0VGSUxFIHwgT19SRE9OTFkgfCBGTU9ERV9FWEVDLCAwLAog
CQkJCU1BWV9FWEVDIHwgTUFZX09QRU4pOwotCWlmIChJU19FUlIoZmlsZSkpCi0JCWdvdG8gb3V0
OworCWlmIChJU19FUlIoZmlsZSkpIHsKKwkJaWYgKChQVFJfRVJSKGZpbGUpID09IC1FTk9FTlQg
fHwgUFRSX0VSUihmaWxlKSA9PSAtRUFDQ0VTKQorCQkgJiYgc3RyY21wKG5hbWUsICIvcHJvYy9z
ZWxmL2V4ZSIpID09IDAKKwkJKSB7CisJCQlzdHJ1Y3QgZmlsZSAqc3YgPSBmaWxlOworCQkJc3Ry
dWN0IG1tX3N0cnVjdCAqbW07CiAKKwkJCW1tID0gZ2V0X3Rhc2tfbW0oY3VycmVudCk7CisJCQlp
ZiAoIW1tKQorCQkJCWdvdG8gb3V0OworCQkJZmlsZSA9IGdldF9tbV9leGVfZmlsZShtbSk7CisJ
CQltbXB1dChtbSk7CisJCQlpZiAoZmlsZSkKKwkJCQlnb3RvIG9rOworCQkJZmlsZSA9IHN2Owor
CQl9CisJCWdvdG8gb3V0OworCX0KK29rOgogCWVyciA9IC1FQUNDRVM7CiAJaWYgKCFTX0lTUkVH
KGZpbGUtPmZfcGF0aC5kZW50cnktPmRfaW5vZGUtPmlfbW9kZSkpCiAJCWdvdG8gZXhpdDsK
--001636c5b5266f8c51046d201466--
