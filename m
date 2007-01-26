Return-Path: <linux-kernel-owner+w=401wt.eu-S1030744AbXAZFDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030744AbXAZFDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 00:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030745AbXAZFDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 00:03:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45638 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030744AbXAZFDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 00:03:08 -0500
Date: Thu, 25 Jan 2007 21:02:45 -0800
From: Andrew Morton <akpm@osdl.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, pj@sgi.com
Subject: Re: [PATCH] nfs: fix congestion control -v4
Message-Id: <20070125210245.3fb0e30e.akpm@osdl.org>
In-Reply-To: <1169739148.6189.68.camel@twins>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
	<20070116135325.3441f62b.akpm@osdl.org>
	<1168985323.5975.53.camel@lappy>
	<Pine.LNX.4.64.0701171158290.7397@schroedinger.engr.sgi.com>
	<1169070763.5975.70.camel@lappy>
	<1169070886.6523.8.camel@lade.trondhjem.org>
	<1169126868.6197.55.camel@twins>
	<1169135375.6105.15.camel@lade.trondhjem.org>
	<1169199234.6197.129.camel@twins>
	<1169212022.6197.148.camel@twins>
	<Pine.LNX.4.64.0701190912540.14617@schroedinger.engr.sgi.com>
	<1169229461.6197.154.camel@twins>
	<1169231212.5775.29.camel@lade.trondhjem.org>
	<1169276500.6197.159.camel@twins>
	<1169482343.6083.7.camel@lade.trondhjem.org>
	<1169739148.6189.68.camel@twins>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 16:32:28 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> +long congestion_wait_interruptible(int rw, long timeout)
> +{
> +	long ret;
> +	DEFINE_WAIT(wait);
> +	wait_queue_head_t *wqh = &congestion_wqh[rw];
> +
> +	prepare_to_wait(wqh, &wait, TASK_INTERRUPTIBLE);
> +	if (signal_pending(current))
> +		ret = -ERESTARTSYS;
> +	else
> +		ret = io_schedule_timeout(timeout);
> +	finish_wait(wqh, &wait);
> +	return ret;
> +}
> +EXPORT_SYMBOL(congestion_wait_interruptible);

I think this can share code with congestion_wait()?

static long __congestion_wait(int rw, long timeout, int state)
{
	long ret;
	DEFINE_WAIT(wait);
	wait_queue_head_t *wqh = &congestion_wqh[rw];

	prepare_to_wait(wqh, &wait, state);
	ret = io_schedule_timeout(timeout);
	finish_wait(wqh, &wait);
	return ret;
}

long congestion_wait_interruptible(int rw, long timeout)
{
	long ret = __congestion_wait(rw, timeout);

	if (signal_pending(current))
		ret = -ERESTARTSYS;
	return ret;
}

it's only infinitesimally less efficient..
