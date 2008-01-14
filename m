Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYANTlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYANTlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYANTl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:41:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46210 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbYANTl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:41:27 -0500
Date: Mon, 14 Jan 2008 19:41:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: zippel@linux-m68k.org, arjan@linux.intel.com
Subject: [oops report analysis] hfs_bnode_split() one (Arjan's #2753)
Message-ID: <20080114194125.GR27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[summary for folks who want to skip blow-by-blow: it's missing check for
hfs_bnode_find() returning ERR_PTR(), there are 2 more places like that
in fs/hfs/* (all in brec.c) and graceful recovery may be non-obvious]

Text below is mostly for the benefit of newbies - it's more along the
lines of 'how to get from bug report to the source of bug', with more
details than normal.  FWIW, this might be worth doing on more or less
regular basis, especially if more people join the fun; everyone gets
their own set of tricks in that area and making it easier to gather
might help a lot of people.  It's not just about oops-tracing per se,
of course - Arjan's site gives a nice collection of those, so that
makes an obvious starting point.

Anyway, here's the report: http://www.kerneloops.org/raw.php?rawid=2753&msgid=

We immediately see that it's i386 (by register names in dump, for one
thing).  The kernel in question is called 2.6.24-rc7-gcdf71a10; everyone
and his dog got a naming scheme of their own, but that one is common
enough - <version>-g<beginning of git tag>.  Which might be from any
number of git repositories, of course, but it doesn't hurt to check the
mainline:
; git log cdf71a|head -5
commit cdf71a10c7b6432d9b48e292cca2c62a0b9fa6cf
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Jan 8 19:47:38 2008 +0100

    futex: Prevent stale futex owner when interrupted/timeout
;

We are in luck - it _is_ pure mainline.  In any case, 2.6.24-rc7 would be
a good starting point, but here we have exact tree.  Very well.

] BUG: unable to handle kernel paging request at virtual address fffffff8
Memory access close to 0.  
] EIP is at hfs_bnode_split+0x2aa/0x340
Search in the tree show that it's either fs/hfs or fs/hfsplus.  Perhaps the
stuff deeper in call chain will tell which one it is.  It's not without
danger, BTW - call trace is to be taken with grain of salt, since it might
be not exact.  In this case we see
] [<c02558ac>] hfs_create+0x3c/0x80
] [<c0179bb8>] vfs_create+0x88/0xd0
in there, which looks like transition from core kernel to fs code, and
hfs_create() is present only in fs/hfs.  So we start looking into fs/hfs.
_However_, hfsplus is worth looking into anyway - there's a good chance
that these two hfs_bnode_split() have shared ancestor, so bugs in one
might very well be present in both.

Now, Arjan's site has the oopsing code already disassembled:
   0:   89 50 0c                mov    %edx,0xc(%eax)
   3:   8b 4d dc                mov    0xffffffdc(%ebp),%ecx
   6:   83 e9 0e                sub    $0xe,%ecx
   9:   89 4d e0                mov    %ecx,0xffffffe0(%ebp)
   c:   29 48 14                sub    %ecx,0x14(%eax)
   f:   29 48 1c                sub    %ecx,0x1c(%eax)
  12:   e9 58 fe ff ff          jmp    0xfffffe6f 
  17:   8b 45 cc                mov    0xffffffcc(%ebp),%eax
  1a:   e8 62 f4 ff ff          call   0xfffff481
  1f:   8b 55 d4                mov    0xffffffd4(%ebp),%edx
  22:   31 c9                   xor    %ecx,%ecx
  24:   89 c3                   mov    %eax,%ebx
  26:   8b 42 08                mov    0x8(%edx),%eax
  29:   89 f2                   mov    %esi,%edx
  2b:*  89 43 04                mov    %eax,0x4(%ebx)     <-- trapping instruction
  2e:   89 d8                   mov    %ebx,%eax
  30:   c7 04 24 0e 00 00 00    movl   $0xe,(%esp)
  37:   e8 85 f0 ff ff          call   0xfffff0c1
  3c:   8b 43 04                mov    0x4(%ebx),%eax
  3f:   31                      .byte 0x31

Nevermind that .byte 0x31 - it's just a truncated instruction (we have one
starting with 31 just several lines above).  The rest looks reasonable
enough - there might be some frame errors in the beginning, but everything
looks sane around the actual location of oops.

And sure enough, it's a memory access - eax = (u32 *)(ebx + 4).  Since
we'd stepped into 0xfffffff8, ebx got to be 0xfffffff4.  Which is confirmed
by the register dump in the beginning of report, so everything fits.

That's actually a nice hint - we have something just below 0 handled as
a pointer.  That's what ERR_PTR() is - in this case we have ebx equal to
ERR_PTR(-12), whatever that might be.  It may be a red herring, of course,
since there's any number of possible ways to get that value, but it's
worth looking into.  Now, _if_ that's some error value, which one would it
be?  Different architectures have slightly diverging error values, but
beginning is common for all of them and sits in asm-generic/errno-base.h
And there we have
#define ENOMEM          12      /* Out of memory */

Well.  So ebx is ERR_PTR(-ENOMEM), for whatever it might be worth.

Now, we need to find where in function that might be.  It's a big one -
according to the trace we are at hfs_bnode_split+0x2aa/0x340, so it's
closer to the end of nearly kilobyte worth of code.  Of course, that
might include something inlined and/or be in a function between
hfs_bnode_split() and the next one we know about (that's not too likely,
though - hfs_bnode_split() itself is static, so we had enough debug
info surviving to see those).

Anyway, it's big - about 100 lines of C in fs/hfs/brec.c.  Not fun -
finding a match will require more information about what that code is
doing.  OK, we have a function call soon after the offending instruction;
let's take a look at it:
  1f:   8b 55 d4                mov    0xffffffd4(%ebp),%edx
  22:   31 c9                   xor    %ecx,%ecx
  24:   89 c3                   mov    %eax,%ebx
  26:   8b 42 08                mov    0x8(%edx),%eax
  29:   89 f2                   mov    %esi,%edx
  2b:*  89 43 04                mov    %eax,0x4(%ebx)
  2e:   89 d8                   mov    %ebx,%eax
  30:   c7 04 24 0e 00 00 00    movl   $0xe,(%esp)
  37:   e8 85 f0 ff ff          call   0xfffff0c1

So we are stuffing some values in a bunch of registers *and* top of the
stack, then calling something.  That's a normal calling sequence for i386
kernel - unlike userland code it's built with -mregparm=3, which makes
the first 3 arguments passed in eax, edx and ecx resp.; the rest goes on
stack as usual.

IOW, that's some_function(eax, edx, ecx, 0xe).  With assignments before
the call itself setting these up.  What do we have there?
	edx = *(u32 *)(ebp - 0x2c);
	ecx = 0;
	ebx = eax;
	eax = *(u32 *)(edx + 8);
	edx = esi;
	*(u32 *)(ebx + 4) = eax;
	eax = ebx;
	some_function(eax, edx, ecx, 0xe);

Ouch.  Let's untangle that a bit.  We have something assigned to edx,
used a bit later and then edx is reassigned.  Ditto for eax.  Let's
massage that into something simpler:
	p = *(u32 *)(ebp - 0x2c);
	ecx = 0;
	ebx = eax;
	q = *(u32 *)(p + 8);
	edx = esi;
	*(u32 *)(ebx + 4) = q;
	eax = ebx;
	some_function(eax, edx, ecx, 0xe);
Aha.  So ebx gets the original value of eax, we use eax a bit and then
restore it to what it used to be.
	p = *(u32 *)(ebp - 0x2c);
	*(u32 *)(eax + 4) = *(u32 *)(p + 8);
	ebx = eax;
	ecx = 0;
	edx = esi;
	some_function(eax, edx, ecx, 0xe);
I.e.
	ebx = eax;
	p = *(u32 *)(ebp - 0x2c);
	*(u32 *)(eax + 4) = *(u32 *)(p + 8);
	some_function(eax, esi, 0, 0xe);
and we get into that with eax == ERR_PTR(-ENOMEM).  Unfortunately, we have
a bunch of 4-argument function calls in there:
        hfs_bnode_write(new_node, &node_desc, 0, sizeof(node_desc));
        hfs_bnode_read(node, &node_desc, 0, sizeof(node_desc));
        hfs_bnode_write(node, &node_desc, 0, sizeof(node_desc));
                hfs_bnode_read(next_node, &node_desc, 0, sizeof(node_desc));
                hfs_bnode_write(next_node, &node_desc, 0, sizeof(node_desc));

Well, well...  So sizeof(node_desc) is 0xe (14), esi contains &node_desc
and eax is new_node, node or next_node.  And function is either
hfs_bnode_read() or hfs_bnode_write().  So <something>node turned out
to be ERR_PTR(-ENOMEM).

Where had that eax come from?  Just before all these assignments we
had
  1a:   e8 62 f4 ff ff          call   0xfffff481
so eax holds the result of some function call.

That's very useful, since we know we'd just set whatever variable that
had been *and* the value being assigned had come from a function call.

Where do we assign anything to those?  Look at the function shows that
we never take address of any of those, so it got to be direct assignment
right in our function.  And each is assigned to only once, actually:
        node = fd->bnode;
        new_node = hfs_bmap_alloc(tree);
	struct hfs_bnode *next_node = hfs_bnode_find(tree, new_node->next);

Now, the first assignment is out - we assign fd->bnode, it's not a function
call *and* our function has no idea how fd->bnode itself had been initialized.
So it's not node.  Assignment to new_node is more promising, but (a) it's
too early in the function and (b) it's immediately followed by
        if (IS_ERR(new_node))
                return new_node;
The latter is a killer - if we had ERR_PTR() in new_node, we'd immediately
left.

That leaves only two possibilities: next_node or something weird (stack
corruption, miscompiled code, etc.).  Let's
see:
	struct hfs_bnode *next_node = hfs_bnode_find(tree, new_node->next);
	next_node->prev = new_node->this;
	hfs_bnode_read(next_node, &node_desc, 0, sizeof(node_desc));
	node_desc.prev = cpu_to_be32(next_node->prev);
	hfs_bnode_write(next_node, &node_desc, 0, sizeof(node_desc));
	hfs_bnode_put(next_node);
and that's it.  Now, if next_node ends up initialized to ERR_PTR(...), the
first assignment will instantly barf, just as it does in report.

All right, that sounds plausible and we narrowed the location down enough
to verify that code matches.  Certainly worth considering before we go
into possible stack corruption or nastier zebras.

; make fs/hfs/brec.s
;

and we can look into whatever the hell hfs_bnode_split() had compiled into.
There's only one call of hfs_bnode_find() in the entire function, so simply
searching for beginning of hfs_bnode_split and then for mentioning of
hfs_bnode_find gets us to
        call    hfs_bnode_find  # 
        xorl    %ecx, %ecx      #
        leal    -26(%ebp), %edx #,
        movl    %eax, %ebx      #, next_node
        movl    8(%esi), %eax   # <variable>.this, <variable>.this
        movl    %eax, 4(%ebx)   # <variable>.this, <variable>.prev
        movl    %ebx, %eax      # next_node, next_node
        movl    $14, (%esp)     #,
        call    hfs_bnode_read  #
        movl    4(%ebx), %eax   # <variable>.prev, <variable>.prev
        xorl    %ecx, %ecx      #
Similar, but not quite...  What are the differences?  edx ends up being
ebp - 26 instead of esi in report.  We still set *(u32 *)(something + 8)
to *(u32 *)((void *)next_node + 4) (actually, next_node->this), but
in locally built code this 'something' is esi and in report it's
*(u32 *)(ebp - 0x2c).  Other than that, they are equivalent.

Let's see what it means: in local build we have ebp - 26 for &node_desc
and esi for new_node; in report we have esi for &node_desc and ebp - 0x2c
for &new_node.  Chalk it up to compiler differences - the local build used
esi to keep the value of &node_desc and report has esi used to store the
value of new_node.  If local variable does not end up in a register, its
address will be epb - constant, so everything's plausible.


OK, we've done about as much as we could with assembler.  It's either
hfs_bnode_find() returning ERR_PTR(-ENOMEM) in
	struct hfs_bnode *next_node = hfs_bnode_find(tree, new_node->next);
	next_node->prev = new_node->this;
with resulting oops (consistent with what we'd observed) or something far
weirder (miscompile/stack corruption/cosmic rays/whatnot).

The next question, of course, is whether hfs_bnode_find() could have
returned ERR_PTR(-ENOMEM).  And sure enough, it could - we have explicit
                return ERR_PTR(-ENOMEM);
and
        return ERR_PTR(-EIO);
in failure exits there.  Moreover, searching for other callers of the
same function shows that almost all of them are followed by check for
IS_ERR(what_we_just_got_from_it).   There are 3 exceptions:
fs/hfs/brec.c:147:              fd->bnode = hfs_bnode_find(tree, new_node->parent);
fs/hfs/brec.c:319:              struct hfs_bnode *next_node = hfs_bnode_find(tree, new_node->next);
fs/hfs/brec.c:411:              fd->bnode = hfs_bnode_find(tree, new_node->parent);

The second one is our bug, other two also appear to be broken.  We are not
quite done yet, though - just adding a check is not enough, we need to decide
what to do if it triggers.  Moreover, it might be that problem is elsewhere
(i.e. that in this place we can't legitimately get ERR_PTR() and adding
a check would just paper over the real bug).  It doesn't look that way,
though - node->next is a number, not a pointer and I don't see anything
that would guarantee anything about it.  hfs_bnode_find() does a lookup
by the number it got in the second argument in some hash and if it's not
found there, we do allocation.  Which can always fail, since we might
be allocating a lot.

Recovery from failure is nasty - we appear to have a double-linked list
of some kind, we'd already split an element in it and written it (presumably
to disk) and now we want to update the pointer going back from the next
element.  Leaving the damn thing as-is means corrupted on-disk list.
Basically, by that point it's too late to do anything.  So the obvious
solution would appear to get the next node earlier, before we'd done
anything.

Other two are nastier - especially the last one, by the look of it.  IOW,
time to pawn it off to maintainer or to do full review of that code with
failure modes on out-of-memory in mind...  Guess which one I'd prefer
for now.

One more thing: remember hfsplus cousin of that function?  As expected,
a look at it shows that the same place has the same problem.  Also needs
treatment.

At that point it's definitely time to dump the entire thing on maintainer:
	* we have a very likely explanation of bug report
	* we have found several more places that have the same breakage
	* we even have a tentative fix for the one that had started the
entire mess
	* further work in that direction requires a full review of quite
a pile of code and comments from maintainer will be needed anyway.

Maintainer for HFS is easily found - it's Roman.  HFS+ is not mentioned
in MAINTAINERS, AFAICS, but git log fs/hfsplus shows commits that went
through Roman's hands, so he's stuck with that part of fun too.  Or at
least ought to know where to bounce it.

Preliminary patch for hfs_bnode_split() follows, other instances left
alone for now.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/hfs/brec.c b/fs/hfs/brec.c
index 8626ee3..d7971d5 100644
--- a/fs/hfs/brec.c
+++ b/fs/hfs/brec.c
@@ -229,7 +229,7 @@ skip:
 static struct hfs_bnode *hfs_bnode_split(struct hfs_find_data *fd)
 {
 	struct hfs_btree *tree;
-	struct hfs_bnode *node, *new_node;
+	struct hfs_bnode *node, *new_node, *next_node;
 	struct hfs_bnode_desc node_desc;
 	int num_recs, new_rec_off, new_off, old_rec_off;
 	int data_start, data_end, size;
@@ -248,6 +248,17 @@ static struct hfs_bnode *hfs_bnode_split(struct hfs_find_data *fd)
 	new_node->type = node->type;
 	new_node->height = node->height;
 
+	if (node->next)
+		next_node = hfs_bnode_find(tree, node->next);
+	else
+		next_node = NULL;
+
+	if (IS_ERR(next_node)) {
+		hfs_bnode_put(node);
+		hfs_bnode_put(new_node);
+		return next_node;
+	}
+
 	size = tree->node_size / 2 - node->num_recs * 2 - 14;
 	old_rec_off = tree->node_size - 4;
 	num_recs = 1;
@@ -261,6 +272,8 @@ static struct hfs_bnode *hfs_bnode_split(struct hfs_find_data *fd)
 		/* panic? */
 		hfs_bnode_put(node);
 		hfs_bnode_put(new_node);
+		if (next_node)
+			hfs_bnode_put(next_node);
 		return ERR_PTR(-ENOSPC);
 	}
 
@@ -315,8 +328,7 @@ static struct hfs_bnode *hfs_bnode_split(struct hfs_find_data *fd)
 	hfs_bnode_write(node, &node_desc, 0, sizeof(node_desc));
 
 	/* update next bnode header */
-	if (new_node->next) {
-		struct hfs_bnode *next_node = hfs_bnode_find(tree, new_node->next);
+	if (next_node) {
 		next_node->prev = new_node->this;
 		hfs_bnode_read(next_node, &node_desc, 0, sizeof(node_desc));
 		node_desc.prev = cpu_to_be32(next_node->prev);
