Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbXCNAuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbXCNAuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 20:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXCNAuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 20:50:07 -0400
Received: from smtp14.orange.fr ([193.252.23.69]:53730 "EHLO smtp14.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbXCNAuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 20:50:05 -0400
X-ME-UUID: 20070314005004326.4F9737000082@mwinf1401.orange.fr
Date: Wed, 14 Mar 2007 02:50:03 +0200
From: Samuel Ortiz <samuel@sortiz.org>
To: David Miller <davem@davemloft.net>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: irda rmmod lockdep trace.
Message-ID: <20070314005003.GA15151@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <20070308225436.GA25184@redhat.com> <20070310174326.GA3816@sortiz.org> <20070312003843.GA3394@sortiz.org> <20070312.164921.71090866.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312.164921.71090866.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 04:49:21PM -0700, David Miller wrote:
> I would strongly caution against adding any run-time overhead just to
> cure a false lockdep warning.  Even adding a new function argument
> is too much IMHO.
> 
> Make the cost show up for lockdep only, perhaps by putting each
> hashbin lock into a seperate locking class?
Does that look better to you:

diff --git a/include/net/irda/irqueue.h b/include/net/irda/irqueue.h
index 335b0ac..67cb434 100644
--- a/include/net/irda/irqueue.h
+++ b/include/net/irda/irqueue.h
@@ -71,6 +71,7 @@ typedef struct hashbin_t {
 	int        hb_size;
 	spinlock_t hb_spinlock;		/* HB_LOCK - Can be used by the user */
 
+	struct lock_class_key hb_lock_key;
 	irda_queue_t* hb_queue[HASHBIN_SIZE] IRDA_ALIGN;
 
 	irda_queue_t* hb_current;
diff --git a/net/irda/irqueue.c b/net/irda/irqueue.c
index 9266233..c72ecee 100644
--- a/net/irda/irqueue.c
+++ b/net/irda/irqueue.c
@@ -370,6 +370,8 @@ hashbin_t *hashbin_new(int type)
 	/* Make sure all spinlock's are unlocked */
 	if ( hashbin->hb_type & HB_LOCK ) {
 		spin_lock_init(&hashbin->hb_spinlock);
+		lockdep_set_class(&hashbin->hb_spinlock,
+				  &hashbin->hb_lock_key);
 	}
 
 	return hashbin;


 

