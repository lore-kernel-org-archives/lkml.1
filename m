Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbYBLBtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbYBLBtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYBLBtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:49:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41555 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYBLBtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:49:10 -0500
Date: Mon, 11 Feb 2008 17:49:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Final removal of FASTCALL()/fastcall
Message-ID: <20080212014908.GE29254@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1202755123.6313.16.camel@brick> <20080211131738.dda66683.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211131738.dda66683.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 01:17:38PM -0800, Andrew Morton wrote:
> On Mon, 11 Feb 2008 10:38:42 -0800
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > All users are gone, remove definitions and comments referring
> > to them.
> 
> I'm still showing occurrences in:
> 
> ./Documentation/RCU/NMI-RCU.txt
> ./Documentation/kprobes.txt
> ./Documentation/uml/UserModeLinux-HOWTO.txt
> ./kernel/rcupdate.c
> 
> The last one is interesting:
> 
> /* FASTCALL no longer exists, this wrapper may no longer be needed */
> static void wakeme_after_rcu(struct rcu_head  *head)
> {
>         struct rcu_synchronize *rcu;
> 
>         rcu = container_of(head, struct rcu_synchronize, head);
>         complete(&rcu->completion);
> }
> 
> The comment is rather ungrammatical/meaningless.  Perhaps it is trying
> to tell us that we can remove this function now?

Hmmm...  A better comment might be something like "Awaken the
corresponding synchronize_rcu() instance now that a grace period has
completed".  Given that the underlying RCU implementation provides
callbacks, synchronize_rcu() will need some sort of callback function.

So, the question is whether "complete()" can be that callback function.
As near as I can tell, the answer is "no", because the RCU callback
function always gets a pointer to a struct rcu_head, which would not
make much sense to the "complete()" function.

In short, I believe that wakeme_after_rcu() needs to stick around.
A better comment for wakeme_after_rcu() would be good, perhaps as shown below.

						Thanx, Paul

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupdate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -urpNa -X dontdiff linux-2.6.24/kernel/rcupdate.c linux-2.6.24-wakeme-comment/kernel/rcupdate.c
--- linux-2.6.24/kernel/rcupdate.c	2008-01-24 14:58:37.000000000 -0800
+++ linux-2.6.24-wakeme-comment/kernel/rcupdate.c	2008-02-11 17:47:11.000000000 -0800
@@ -601,7 +601,10 @@ struct rcu_synchronize {
 	struct completion completion;
 };
 
-/* Because of FASTCALL declaration of complete, we use this wrapper */
+/*
+ * Awaken the corresponding synchronize_rcu() instance now that a
+ * grace period has elapsed.
+ */
 static void wakeme_after_rcu(struct rcu_head  *head)
 {
 	struct rcu_synchronize *rcu;
