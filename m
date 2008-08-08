Return-Path: <linux-kernel-owner+w=401wt.eu-S1763151AbYHHW0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763151AbYHHW0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbYHHW0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:26:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:63491 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYHHW0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=ssvP+CzEUd5h4MIUJf+BZJv1PWVGXCztfPATVMeQkN+1RytHCbZAwTQaDK924CcUL+
         oGkJocWj1XZEYfb3FPbhmSe/Uvt4QZna4BWrtvqYJZLR49+TwanntnHAnYMn/1AvhRzG
         QUllX8MNWywFgIhkibn0o23Fyg5jzF6W/OlOA=
Date: Sat, 9 Aug 2008 03:55:56 +0530
From: Rabin Vincent <rabin@rab.in>
To: Huang Ying <ying.huang@intel.com>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] lockdep: handle chains involving classes defined in
	modules
Message-ID: <20080808222555.GA10656@debian>
References: <20080806121650.GA3119@alice> <20080806124134.GA3615@alice> <20080807205340.GA1747@debian> <20080807205729.GB1747@debian> <1218165877.22039.23.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218165877.22039.23.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 11:24:37AM +0800, Huang Ying wrote:
> On Fri, 2008-08-08 at 02:27 +0530, Rabin Vincent wrote:
> > /proc/lockdep_chains currently oopses after any module which creates and
> > uses a lock is unloaded.  This is because one of the chains involves a
> > class which was defined in the module just unloaded.
> > 
> > The classes are already correctly taken care of using the
> > all_lock_classes which keeps track of all active lock classses.  Add a
> > similar all_lock_chains list and use it for keeping track of chains.
> > 
[...]
> 
> I think there is a simpler method to deal with this.

Yes.  I went with the all_lock_chains list approach because there was
similar code already being used to keep track of lock_class structures.

> - Mark class as useless during zap_class()
> - When output lock_chain, if some classes are useless, do not output the
> class.

Like the patch below?  I set ->key to NULL after zapping the class and
use that as a condition to not print the class' information.  The only
issue is that with this patch there will be some chains output with no
locks listed under them.

---
    lockdep: handle chains involving classes defined in modules
    
    /proc/lockdep_chains currently oopses after any module which creates and
    uses a lock is unloaded.  This is because one of the chains involves a
    class which was defined in the module just unloaded.
    
    Solve this by marking the classes as unused and not printing information
    about the unused classes.
    
    Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
    Signed-off-by: Rabin Vincent <rabin@rab.in>

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index d38a643..8ade874 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2988,6 +2988,7 @@ static void zap_class(struct lock_class *class)
 	list_del_rcu(&class->hash_entry);
 	list_del_rcu(&class->lock_entry);
 
+	class->key = NULL;
 }
 
 static inline int within(const void *addr, void *start, unsigned long size)
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 9b0e940..f09b6c7 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -229,6 +229,9 @@ static int lc_show(struct seq_file *m, void *v)
 
 	for (i = 0; i < chain->depth; i++) {
 		class = lock_chain_get_class(chain, i);
+		if (!class->key)
+			continue;
+
 		seq_printf(m, "[%p] ", class->key);
 		print_name(m, class);
 		seq_puts(m, "\n");
