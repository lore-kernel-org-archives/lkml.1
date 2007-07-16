Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbXGPWUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbXGPWUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbXGPWUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:20:38 -0400
Received: from ns1.coraid.com ([65.14.39.133]:27543 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752861AbXGPWUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:20:37 -0400
Date: Mon, 16 Jul 2007 18:17:44 -0400
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg K-H <greg@kroah.com>
Subject: [PATCH] stacked ifs (was Re: [PATCH 02/12] handle multiple network paths to AoE device)
Message-ID: <20070716221744.GM18477@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com> <60bd316bfa72fb225cefad39569999e583f4f72e.1182883861.git.ecashin@coraid.com> <20070702212949.5a1a1a31.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070702212949.5a1a1a31.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 09:29:49PM -0700, Andrew Morton wrote:
> On Tue, 26 Jun 2007 14:50:10 -0400 "Ed L. Cashin" <ecashin@coraid.com> wrote:
...
> > +static struct frame *
> > +freeframe(struct aoedev *d)
> >  {
> > +	struct frame *f, *e;
> > +	struct aoetgt **t;
> > +	ulong n;
> > +
> > +	if (d->targets[0] == NULL) {	/* shouldn't happen, but I'm paranoid */
> > +		printk(KERN_ERR "aoe: NULL TARGETS!\n");
> > +		return NULL;
> > +	}
> > +	t = d->targets;
> > +	do {
> > +		if (t != d->htgt)
> > +		if ((*t)->ifp->nd)
> > +		if ((*t)->nout < (*t)->maxout) {
> 
> ugh.  Do this:
> 
> 	do {
> 		if (t == d->htgt)
> 			continue;
> 		if (!(*t)->ifp->nd)
> 			continue;
> 		if ((*t)->nout >= (*t)->maxout)
> 			continue;
> 			
> 		<stuff>
> 	} while (++t ...)

Do you think the "stacked ifs" in the first version above could be
accepted as a convenient extension to the K&R-based conventions in
Documentation/CodingStyle?  Brian Kerhnighan (the "K" in "K&R") and
Ken Thompson, were among the UNIX hackers who produced the UNIX v7
files that have stacked ifs:

  namei.c, dump.c, iostat.c od.c sa.c, vplot.c, refer/what2.c,
  sed/sed1.c, tbl/t8.c, chess/{agen, play, stdin}.c

Certainly, Linux isn't UNIX, but stacked ifs needn't be treated as
foreign.  They're in the K&R tradition that Documentation/CodingStyle
is based on.

Stacked ifs are functionally equivalent to a single if with its
conditionals joined by "&&".  Once that is retained, they are not at
all difficult to recognize and understand.  And they have some
advantages over the single if that uses "&&".

When editing code, it is easier to remove conditionals that are no
longer needed, or to arrange conditionals in a different order.
Conditional expressions stand out clearly.

When stacked ifs are in use, the resulting patches can be easier to
read because fewer lines need to change (compared to splitting on the
&&), and also simply because the text is more regular when it comes to
parentheses and ampersands.  There is less distracting noise.

Of course, my primary motivation is for us to be able to contribute
aoe driver patches that use this style, and that would be fantastic,
but I don't think it is unrealistic to say that the adoption of this
style would benefit others, helping to make patches easier to review
in some cases.

Understanding it only takes an understanding of C itself, so the only
"new" change would be a slight and justifiable loosening of the
indentation policy.

Signed-off-by: "Ed L. Cashin" <ecashin@coraid.com>

---
 Documentation/CodingStyle |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index a667eb1..bb2bb57 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -94,6 +94,27 @@ void fun(int a, int b, int c)
 		next_statement;
 }
 
+One way to break a long condition in an if statement is to use stacked
+ifs.  The following code extracts are equivalent, but the version with
+stacked ifs is easier to read and edit, and it generates more specific
+patches.
+
+	/* version one: stacked ifs */
+	if (condition)
+	if (condition2)
+	if (condition3)
+	if (condition4)
+		first_statement;
+	else
+		next_statement;
+
+	/* version two: logical and */
+	if (condition1 && condition2 && condition3 && condition4)
+		first_statement;
+	else
+		next_statement;
+
+
 		Chapter 3: Placing Braces and Spaces
 
 The other issue that always comes up in C styling is the placement of
-- 
1.5.2.1


-- 
  Ed L Cashin <ecashin@coraid.com>
