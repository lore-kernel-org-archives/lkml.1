Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZHLFlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZHLFlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 01:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZHLFlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 01:41:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59292 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbZHLFle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 01:41:34 -0400
Message-ID: <4A825601.60000@redhat.com>
Date: Wed, 12 Aug 2009 08:41:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Pierre Ossman <drzeus-list@drzeus.cx>, Minchan Kim <minchan.kim@gmail.com>,
       kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, netdev@vger.kernel.org
Subject: Re: Page allocation failures in guest
References: <20090713115158.0a4892b0@mjolnir.ossman.eu> <4A811545.5090209@redhat.com> <200908121249.51973.rusty@rustcorp.com.au> <200908121501.53167.rusty@rustcorp.com.au>
In-Reply-To: <200908121501.53167.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2009 08:31 AM, Rusty Russell wrote:
> +static void refill_work(struct work_struct *work)
> +{
> +	struct virtnet_info *vi;
> +	bool still_empty;
> +
> +	vi = container_of(work, struct virtnet_info, refill);
> +	napi_disable(&vi->napi);
> +	try_fill_recv(vi, GFP_KERNEL);
> +	still_empty = (vi->num == 0);
> +	napi_enable(&vi->napi);
> +
> +	/* In theory, this can happen: if we don't get any buffers in
> +	 * we will*never*  try to fill again.  Sleeping in keventd if
> +	 * bad, but that is worse. */
> +	if (still_empty) {
> +		msleep(100);
> +		schedule_work(&vi->refill);
> +	}
> +}
> +
>    

schedule_delayed_work()?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

