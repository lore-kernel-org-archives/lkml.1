Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbYLAVH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbYLAVH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYLAVHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:07:47 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36810 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYLAVHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:07:46 -0500
Subject: Re: [RFC v10][PATCH 09/13] Restore open file descriprtors
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Linus Torvalds <torvalds@osdl.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <49345086.4@cs.columbia.edu>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
	 <1227747884-14150-10-git-send-email-orenl@cs.columbia.edu>
	 <20081128112745.GR28946@ZenIV.linux.org.uk>
	 <1228159324.2971.74.camel@nimitz>  <49344C11.6090204@cs.columbia.edu>
	 <1228164873.2971.95.camel@nimitz>  <49345086.4@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 13:07:31 -0800
Message-Id: <1228165651.2971.99.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 16:00 -0500, Oren Laadan wrote:
> > Is that sufficient?  It seems like we're depending on the fd's reference
> > to the 'struct file' to keep it valid in the hash.  If something happens
> > to the fd (like the other thread messing with it) the 'struct file' can
> > still go away.
> > 
> > Shouldn't we do another get_file() for the hash's reference?
> 
> When a shared object is inserted to the hash we automatically take another
> reference to it (according to its type) for as long as it remains in the
> hash. See:  'cr_obj_ref_grab()' and 'cr_obj_ref_drop()'.  So by moving that
> call higher up, we protect the struct file.

That's kinda (and by kinda I mean really) disgusting.  Hiding that two
levels deep in what is effectively the hash table code where no one will
ever see it is really bad.  It also makes you lazy thinking that the
hash code will just know how to take references on whatever you give to
it.

I think cr_obj_ref_grab() is hideous obfuscation and needs to die.
Let's just do the get_file() directly, please.

-- Dave

