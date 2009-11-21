Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbZKUA4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbZKUA4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 19:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbZKUA4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 19:56:09 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:64519 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZKUA4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 19:56:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UnqC0C2m5ANFnfyDAX0EgUp+OQ9nwKyrKE2DGscy1eVHzUfgMGe3wyqAtoNXLaaP/W
         w5rZ2JapoEkvvJmXpigqGJD0em6Ycg61Dd380bxkOZkKLMKEEJ6liV98XZP7K4ttWYg7
         ecybHhOeJp8b+v346iwWr3ucTVRLS6QxEw5T0=
MIME-Version: 1.0
Date: Fri, 20 Nov 2009 16:56:14 -0800
Message-ID: <3f43f78b0911201656o6d222e6fkf5ef8533c8ee6e16@mail.gmail.com>
Subject: Easier way to generate stuff like asm-offsets.
From: Kaz Kylheku <kkylheku@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all,

You can use declarations and the ``nm'' utility to discover sizes of
types, structure offsets and stuff like that.

There is no need to grep material from the assembly code itself.

I'm looking into this as a technique for to use in ./configure scripts
when a program is being cross-compiled.

Then I remembered that the Linux kernel does something to pull out
structure member offsets
for use in assembly code. How are they doing that, I wondered? I took
a look and saw that it
was done with a complicated hack.

Here is the simple trick:

  /* file test.c */

  #include <stddef.h>  /* for offsetof macro */

  struct foo { char padding[43]; int member; };

  char offsetof_foo_member[offsetof(struct foo, member)];

Now we compile test.c:

$ /path/to/toolchain/bin/arch-prefix-gcc test.c -c

Then we can use the ``nm'' tool (the toolchain should have binutils in it):

$ /path/to/toolchain/bin/arch-prefix-nm -t d -P foo.c   # decimal
output, posix format
offsetof_foo_member C 00000044 00000044

There we go, 44 bytes.  Simple.  This is almost an #include file;
we just have to do some simple filtering, such as:

$ /path/to/toolchain/bin/arch-prefix-nm -t d -P test.o | awk '{ print
"#define", $1, $4 }'
#define offsetof_foo_member 00000044

:)

Cheers ...
