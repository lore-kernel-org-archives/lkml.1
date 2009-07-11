Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbZGKIQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbZGKIQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZGKIQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:16:35 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:2696 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZGKIQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=x8nIr5jGyTsdCKr+QcB5eWzbeFlO+JCDsRex6HCkAh6QK+U01X95AkMPATerfWD+Kv
         MRVdFKA6COgY12d5ZjBJfoziqT1aGRSPLPbQ1mMnWhKzlcQD2CUOMLuhGQTzUqcZxSp3
         XoLgwR83eM1g4pKZlpLuXk4+22f4aXBLyXJ/c=
MIME-Version: 1.0
In-Reply-To: <F4B972C6-3FAB-49DB-A409-36B5EF2A7684@earthlink.net>
References: <F4B972C6-3FAB-49DB-A409-36B5EF2A7684@earthlink.net>
From: Chris Snook <chris.snook@gmail.com>
Date: Sat, 11 Jul 2009 04:16:13 -0400
Message-ID: <13a12eea0907110116g62bd0aa1n6f1d35a067351ff1@mail.gmail.com>
Subject: Re: Suggested code change : Simple : Scale pdflush threads from 
	desktop to server
To: Mitchell Erblich <erblichs@earthlink.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 9:25 PM, Mitchell Erblich<erblichs@earthlink.net> wrote:
> Group,
>
>                pdflush threads clean dirty pages
>
>          Under the past simple assumption that a greater number of
>          page daemon threads will have the TENDENCY to clean
>          the pages faster.
>
>        Another assumption is that a server will have at least 2x / 4x the
>        number of drives and memory, so allocating more pdflush() threads
>        makes sense.

That's a rather sweeping generalization.

>        Relying on a recent change, code base on whether the system is
>        a desktop or a server, scale the number of pdthreads() which would
>        result in the below code change.
>
>        The suggestion is to double the MIN number of threads and set the
>        MAX number to 4x.
>
>        ./mm/pdflush.c
>        /* Scale for a server */
>        #define MIN_PDFLUSH_THREADS     4               /* 2x desktop value
> */
>        #define MAX_PDFLUSH_THREADS     32              /* 4x desktop value
> */

So, you're taking a well-established and empirically validated set of
constants, and changing it only in the case where users are least
tolerant of change?  I agree that the existing pdflush tuning is a bit
of a kludge, but this just adds more noise to the data we need to
analyze and optimize pdflush.

>        /*
>         * secondary suggestion is to add a DEBUG type /var/log/system
> messages that
>         * will rate limit independent of desktop or server.
>         */
>
>        else if (nr_pdflush_threads == MAX_PDFLUSH_THREADS) {
>                   /* optional PDFLUSH msg */
>                   if (printk_ratelimit() {
>                                                    printk(KERN_INFO
> "MAX_PDFLUSH_THREADS Limited\n");
>                   }
>         }

Log messages, even at debug level, for normal conditions are a really bad idea.

pdflush definitely needs work, but twiddling constants will, at best,
optimize it for a small subset of the user base for a brief period of
time.  We really need patches that do intelligent things based on
system resources and load, and we need data to support them.

-- Chris
