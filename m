Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYCKRf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYCKRf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYCKRft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:35:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311AbYCKRfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:35:48 -0400
Date: Tue, 11 Mar 2008 10:35:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] lib: introduce call_once()
Message-Id: <20080311103517.5b6dc23f.akpm@linux-foundation.org>
In-Reply-To: <961aa3350803110527g4d6654ew34847807e46da315@mail.gmail.com>
References: <20080310145704.GA6396@APFDCB5C>
	<20080310204853.3108d21c.akpm@linux-foundation.org>
	<200803111510.52761.nickpiggin@yahoo.com.au>
	<20080310212108.5882011e.akpm@linux-foundation.org>
	<961aa3350803110527g4d6654ew34847807e46da315@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 21:27:30 +0900
"Akinobu Mita" <akinobu.mita@gmail.com> wrote:

> 2008/3/11, Andrew Morton <akpm@linux-foundation.org>:
> > On Tue, 11 Mar 2008 15:10:52 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >
> >  > > #define ONCE()                                              \
> >  > >     ({                                              \
> >  > >             static long flag;                       \
> >  > >                                                     \
> >  > >             return !test_and_set_bit(0, flag);      \
> >  > >     })
> >  > >
> >  > > and then callers can do
> >  > >
> >  > >     if (ONCE())
> >  > >             do_something();
> >  > >
> >  > > ?
> 
> This cannot be used directly in the conversions of patch 2 - 5.
> Because the callers of call_once() in patch 2 - 5 need to wait for the
> complition of "init_routine". Some blocking mechanism is needed.

Of course it can be used in those places.  Here's the idr.c conversion:

--- a/lib/idr.c~a
+++ a/lib/idr.c
@@ -585,14 +585,6 @@ static void idr_cache_ctor(struct kmem_c
 	memset(idr_layer, 0, sizeof(struct idr_layer));
 }
 
-static  int init_id_cache(void)
-{
-	if (!idr_layer_cache)
-		idr_layer_cache = kmem_cache_create("idr_layer_cache",
-			sizeof(struct idr_layer), 0, 0, idr_cache_ctor);
-	return 0;
-}
-
 /**
  * idr_init - initialize idr handle
  * @idp:	idr handle
@@ -602,7 +594,9 @@ static  int init_id_cache(void)
  */
 void idr_init(struct idr *idp)
 {
-	init_id_cache();
+	if (ONCE())
+		idr_layer_cache = kmem_cache_create("idr_layer_cache",
+			sizeof(struct idr_layer), 0, 0, idr_cache_ctor);
 	memset(idp, 0, sizeof(struct idr));
 	spin_lock_init(&idp->lock);
 }


