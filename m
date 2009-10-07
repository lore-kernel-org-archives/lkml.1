Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZJGDtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZJGDtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZJGDtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:49:08 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45533 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbZJGDtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uqp/XPDOxdiG9wj7r6j6WmdZ/QimrXc17RrVoHfYliGjRJRx7JDrvkebZ0QOzTAaID
         NpjtjiiGupHl4dyYXXLxc68eMJqxofQUUs631MIyqRY1XjUAY570Hf6TdwQ1mjHxU2J9
         xqRRoN7s1oJgSWQcyhdmdzU78RvWFqajKriMY=
MIME-Version: 1.0
In-Reply-To: <604427e00910061559v34590d49x4cdd01b16df6fb1e@mail.gmail.com>
References: <20091006112803.5FA5.A69D9226@jp.fujitsu.com>
	 <20091006114052.5FAA.A69D9226@jp.fujitsu.com>
	 <604427e00910061559v34590d49x4cdd01b16df6fb1e@mail.gmail.com>
Date: Wed, 7 Oct 2009 12:48:31 +0900
X-Google-Sender-Auth: 9769421f9e619689
Message-ID: <2f11576a0910062048j1967de28ve33a134df6d4ab9c@mail.gmail.com>
Subject: Re: [PATCH 2/2] mlock use lru_add_drain_all_async()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hello KOSAKI-san,
>
> Few questions on the lru_add_drain_all_async(). If i understand
> correctly, the reason that we have lru_add_drain_all() in the mlock()
> call is to isolate mlocked pages into the separate LRU in case they
> are sitting in pagevec.
>
> And I also understand the RT use cases you put in the patch
> description, now my questions is that do we have race after applying
> the patch? For example that if the RT task not giving up the cpu by
> the time mlock returns, you have pages left in the pagevec which not
> being drained back to the lru list. Do we have problem with that?

This patch don't introduce new race. current code has following race.

1. call mlock
2. lru_add_drain_all()
3. another cpu grab the page into its pagevec
4. actual PG_mlocked processing

I'd like to explain why this code works. linux has VM_LOCKED in vma
and PG_mlocked in page.  if we failed to turn on PG_mlocked, we can
recover it at vmscan phase by VM_LOCKED.

Then, this patch effect are
  - increase race possibility a bit
  - decrease RT-task problem risk

Thanks.
