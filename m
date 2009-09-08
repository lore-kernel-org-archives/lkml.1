Return-Path: <linux-kernel-owner+w=401wt.eu-S1751481AbZIHQLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbZIHQLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZIHQLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:11:36 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:57629 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbZIHQLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:11:35 -0400
Subject: Re: [PATCH v3 2/5] kmemleak: add clear command support
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, penberg@cs.helsinki.fi,
       mcgrof@gmail.com
In-Reply-To: <1252111494-7593-3-git-send-email-lrodriguez@atheros.com>
References: <1252111494-7593-1-git-send-email-lrodriguez@atheros.com>
	 <1252111494-7593-3-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 08 Sep 2009 17:11:28 +0100
Message-Id: <1252426288.12145.112.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Sep 2009 16:11:29.0141 (UTC) FILETIME=[05F5D250:01CA309F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 17:44 -0700, Luis R. Rodriguez wrote:
>  /*
> + * We use grey instead of black to ensure we can do future
> + * scans on the same objects. If we did not do future scans
> + * these black objects could potentially contain references to
> + * newly allocated objects in the future and we'd end up with
> + * false positives.
> + */
> +static void kmemleak_clear(void)
> +{
> +	struct kmemleak_object *object;
> +	unsigned long flags;
> +
> +	stop_scan_thread();
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(object, &object_list, object_list) {
> +		spin_lock_irqsave(&object->lock, flags);
> +		if ((object->flags & OBJECT_REPORTED) &&
> +		    unreferenced_object(object))
> +			object->min_count = -1;
> +		spin_unlock_irqrestore(&object->lock, flags);
> +	}
> +	rcu_read_unlock();
> +
> +	start_scan_thread();
> +}

Do we need to stop and start the scanning thread here? When starting it,
it will trigger a memory scan automatically. I don't think we want this
as a side-effect, so I dropped these lines from your patch.

Also you set min_count to -1 here which means black object, so a
subsequent patch corrects it. I'll set min_count to 0 here in case
anyone bisects over it.

-- 
Catalin

