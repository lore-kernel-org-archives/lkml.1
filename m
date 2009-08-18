Return-Path: <linux-kernel-owner+w=401wt.eu-S932428AbZHRATQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbZHRATQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 20:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758426AbZHRATP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 20:19:15 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43569 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZHRATP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 20:19:15 -0400
Subject: Re: [patch 1/3] flex_array: fix get function for elements in base
 starting at non-zero
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 17:19:11 -0700
Message-Id: <1250554751.10725.22076.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 16:46 -0700, David Rientjes wrote:
> This fixes the bug by only checking for NULL parts when all elements do
> not fit in the base structure when flex_array_get() is used.  Otherwise,
> fa_element_to_part_nr() will always be 0 since there are no parts
> structures needed and such element may never have been put.  Thus, it
> will remain NULL due to the kzalloc() of the base.

Whew.  That one took me way longer to grok than it should have.  Thanks
for finding this.  Just to be clear, there is only a bug in
flex_array_get(), right?  The flex_array_put() change is completely
separate and is intended to optimize the case where we know the pointer
can't be NULL.

This definitely fixes a bug, but do you mind if we do it a bit
differently?  The compiler should be able to take care of figuring out
when that pointer actually needs to be checked, and I think it looks a
bit nicer as it stands.   

--

When trying to use the 'packed' flex_array format, we take the space
normally used the ->parts[] pointers and instead use it to store user
data.  When doing that, we may have any kind of data in the ->parts[]
pointers that the user puts there.  The user may be storing '\0's there
or whatever else they want.  If they do that (or the data are
uninitialized), we might falsely trigger this NULL check.

This makes sure not to check the contents of the ->parts[] array until
after we've determined that we are not going to use the 'packed' mode.  

---

 linux-2.6.git-dave/lib/flex_array.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/flex_array.c~fa-fixes-0 lib/flex_array.c
--- linux-2.6.git/lib/flex_array.c~fa-fixes-0	2009-08-17 17:02:51.000000000 -0700
+++ linux-2.6.git-dave/lib/flex_array.c	2009-08-17 17:02:51.000000000 -0700
@@ -257,11 +257,11 @@ void *flex_array_get(struct flex_array *
 
 	if (element_nr >= fa->total_nr_elements)
 		return NULL;
-	if (!fa->parts[part_nr])
-		return NULL;
 	if (elements_fit_in_base(fa))
 		part = (struct flex_array_part *)&fa->parts[0];
 	else
 		part = fa->parts[part_nr];
+	if (!part)
+		return NULL;
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
_


-- Dave

