Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZKMSdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZKMSdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbZKMSdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:33:12 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:53409 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbZKMSdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:33:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IRRty2AnhBpnT9t8cOgzD1suPpRAyRakE/8vZu3gKLTaCBgh/kQJghqXSp1yPgEOon
         /gQlcJ3HDDnHkYcu6U/c2d2/ziZYMLYT4v05WHPBUIkFYXP+RHXUsC382kKRYQJ4hXII
         II9sr3/qLNRjA/xc/2TspO4dfJDuCJDSjFgq8=
MIME-Version: 1.0
In-Reply-To: <20091113181557.GM29804@csn.ul.ie>
References: <20091113142608.33B9.A69D9226@jp.fujitsu.com>
	 <20091113135443.GF29804@csn.ul.ie>
	 <20091114023138.3DA5.A69D9226@jp.fujitsu.com>
	 <20091113181557.GM29804@csn.ul.ie>
Date: Sat, 14 Nov 2009 03:33:16 +0900
X-Google-Sender-Auth: 9e621a805d035b55
Message-ID: <2f11576a0911131033w4a9e6042k3349f0be290a167e@mail.gmail.com>
Subject: Re: [PATCH] vmscan: Stop kswapd waiting on congestion when the min 
	watermark is not being met
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2092,8 +2102,12 @@ loop_again:
>                 * OK, kswapd is getting into trouble.  Take a nap, then take
>                 * another pass across the zones.
>                 */
> -               if (total_scanned && priority < DEF_PRIORITY - 2)
> -                       congestion_wait(BLK_RW_ASYNC, HZ/10);
> +               if (total_scanned && (priority < DEF_PRIORITY - 2)) {
> +                       if (!has_under_min_watermark_zone)

if I am correct, we must to remove "!".


> +                               count_vm_event(KSWAPD_NO_CONGESTION_WAIT);
> +                       else
> +                               congestion_wait(BLK_RW_ASYNC, HZ/10);
> +               }
