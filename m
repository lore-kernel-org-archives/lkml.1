Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbZGVWAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbZGVWAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZGVWAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:00:21 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47702 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbZGVWAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:00:20 -0400
Subject: Re: [RFCv2][PATCH] flexible array implementation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mike Waychison <mikew@google.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       bblum@google.com, linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com
In-Reply-To: <4A676ECC.1090400@google.com>
References: <20090721220017.60A219D3@kernel>  <4A676ECC.1090400@google.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 15:00:17 -0700
Message-Id: <1248300017.24021.344.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 15:55 -0400, Mike Waychison wrote:
> > +#define FLEX_ARRAY_INIT(size, total) {{{\
> > +     .element_size = (size),         \
> > +     .nr_elements = 0,               \
> > +}}}
> > +
> 
> It's not clear how this guy is used.  It will initialize a flex_array, 
> but how is somebody expected to free the parts that get associated with it?

I tried to make that a bit more clear with the kerneldocs.
flex_array_free_parts() will free just the "parts" without touching the
"base" structure.  Otherwise, this macro is used in the same way as
RADIX_TREE_INIT().

> Is there a fancy way to make declaring a flex_array on stack a 
> compile-time error?

Not that I know of.  One thing that I did which makes this a _bit_
easier to detect is that sizeof(struct flex_array)==PAGE_SIZE instead of
just leaving a "void members[0]" at the end of the struct.  That means
that scripts/checkstack.pl should spot these.

I just double-checked:

$ objdump -d ../mhp-build/i386-qemu-smp/vmlinux | scripts/checkstack.pl i386
0xc02499d8 min_free_kbytes_sysctl_handler [vmlinux]:	4096
0xc0276619 do_sys_poll [vmlinux]:			896
0xc0276b49 do_select [vmlinux]:				704
...

That's after I added a 'struct flex_array f;' in
min_free_kbytes_sysctl_handler().

I'm happy to hear of anybody else's tricks, though.  I guess I could do
a WARN_ONCE() in some of the flex_array*() functions if we detect an
address that looks to be on the stack.  But, I can't think of any fancy
compile-time ones.

-- Dave

