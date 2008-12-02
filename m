Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbYLBBbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbYLBBbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 20:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYLBBbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 20:31:17 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52753 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYLBBbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 20:31:15 -0500
Subject: Re: [RFC v10][PATCH 09/13] Restore open file descriprtors
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Linus Torvalds <torvalds@osdl.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ZenIV.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1228165651.2971.99.camel@nimitz>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
	 <1227747884-14150-10-git-send-email-orenl@cs.columbia.edu>
	 <20081128112745.GR28946@ZenIV.linux.org.uk>
	 <1228159324.2971.74.camel@nimitz> <49344C11.6090204@cs.columbia.edu>
	 <1228164873.2971.95.camel@nimitz> <49345086.4@cs.columbia.edu>
	 <1228165651.2971.99.camel@nimitz>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 17:31:08 -0800
Message-Id: <1228181468.2971.146.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 13:07 -0800, Dave Hansen wrote:
> > When a shared object is inserted to the hash we automatically take another
> > reference to it (according to its type) for as long as it remains in the
> > hash. See:  'cr_obj_ref_grab()' and 'cr_obj_ref_drop()'.  So by moving that
> > call higher up, we protect the struct file.
> 
> That's kinda (and by kinda I mean really) disgusting.  Hiding that two
> levels deep in what is effectively the hash table code where no one will
> ever see it is really bad.  It also makes you lazy thinking that the
> hash code will just know how to take references on whatever you give to
> it.
> 
> I think cr_obj_ref_grab() is hideous obfuscation and needs to die.
> Let's just do the get_file() directly, please.

Well, I at least see why you need it now.  The objhash thing is trying
to be a pretty generic hash implementation and it does need to free the
references up when it is destroyed.  Instead of keeping a "hash of
files" and a "hash of pipes" or other shared objects, there's just a
single hash for everything.

One alternative here would be to have an ops-style release function that
gets called instead of what we have now:
        
        static void cr_obj_ref_drop(struct cr_objref *obj)
        {
                switch (obj->type) {
                case CR_OBJ_FILE:
                        fput((struct file *) obj->ptr);
                        break;
                default:
                        BUG();
                }
        }
        
        static void cr_obj_ref_grab(struct cr_objref *obj)
        {
                switch (obj->type) {
                case CR_OBJ_FILE:
                        get_file((struct file *) obj->ptr);
                        break;
                default:
                        BUG();
                }
        }

That would make it something like:

struct cr_obj_ops {
	int type;
	void (*release)(struct cr_objref *obj);
};

void cr_release_file(struct cr_objref *obj)
{
	struct file *file = obj->ptr;
	put_file(file);
}

struct cr_obj_ops cr_file_ops = {
	.type = CR_OBJ_FILE,
	.release = cr_release_file,
};


And the add operation becomes:

	get_file(file);
	new = cr_obj_add_ptr(ctx, file, &objref, &cr_file_ops, 0);

with 'cr_file_ops' basically replacing the CR_OBJ_FILE that got passed
before.

I like that because it only obfuscates what truly needs to be abstracted
out: the release side.  Hiding that get_file() is really tricky.

But, I guess we could also just kill cr_obj_ref_grab(), do the
get_file() explicitly and still keep cr_obj_ref_drop() as it is now.

-- Dave

