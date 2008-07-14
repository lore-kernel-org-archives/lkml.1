Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYGNNhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYGNNhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 09:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYGNNg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 09:36:56 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:36648 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbYGNNgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:36:55 -0400
Subject: Re: [PATCH][RFC] dirty balancing for cgroups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       menage@google.com, kamezawa.hiroyu@jp.fujitsu.com,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080709060034.0CB2D5A29@siro.lan>
References: <20080709060034.0CB2D5A29@siro.lan>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 15:37:17 +0200
Message-Id: <1216042637.12595.76.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-09 at 15:00 +0900, YAMAMOTO Takashi wrote:
> hi,
> 
> the following patch is a simple implementation of
> dirty balancing for cgroups.  any comments?
> 
> it depends on the following fix:
> 	http://lkml.org/lkml/2008/7/8/428
> 
> YAMAMOTO Takashi
> 
> 
> Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> ---

Yamamoto-san,

> @@ -408,7 +412,11 @@ get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
>  
>  		*pbdi_dirty = bdi_dirty;
>  		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
> -		task_dirty_limit(current, pbdi_dirty);
> +		task_dirty = *pbdi_dirty;
> +		task_dirty_limit(current, &task_dirty);
> +		cgroup_dirty = *pbdi_dirty;
> +		memdirtylimitcgroup_dirty_limit(current, &cgroup_dirty);
> +		*pbdi_dirty = min(task_dirty, cgroup_dirty);
>  	}
>  }

I think this is wrong - is basically breaks task dirty throttling within
groups. You'd need a multiplicative operation, something like:

  bdi_dirty = dirty * p(bdi) * p(cgroup) * (1 - p(task))

However then we still have problems... see the next email further down
the thread.

