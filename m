Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbZE2U2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbZE2U2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763975AbZE2UWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:22:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:41818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763991AbZE2UWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:22:31 -0400
Subject: Re: [PATCH tip 1/1] perf_counter tools: Add locking to perf top
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090529200307.GR4747@ghostprotocols.net>
References: <20090529200307.GR4747@ghostprotocols.net>
Content-Type: text/plain
Date: Fri, 29 May 2009 22:22:17 +0200
Message-Id: <1243628537.6645.106.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 17:03 -0300, Arnaldo Carvalho de Melo wrote:
>         /* Sort the active symbols */
> -       list_for_each_entry_safe(syme, n, &active_symbols, node) {
> -               if (syme->count[0] != 0) {
> +       pthread_mutex_lock(&active_symbols_lock);
> +       syme = list_entry(active_symbols.next, struct sym_entry, node);
> +       pthread_mutex_unlock(&active_symbols_lock);
> +
> +       list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
> +               syme->snap_count = syme->count[0];
> +               if (syme->snap_count != 0) {
> +                       syme->weight = sym_weight(syme);

That looks wrong, you basically do a fancy cast while holding the lock,
then you overwrite the variable doing a list iteration without holding
the lock.

If list_add and list_del are under a lock, the iteration should be too.

