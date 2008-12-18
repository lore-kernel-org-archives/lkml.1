Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbYLRWoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbYLRWoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYLRWnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:43:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbYLRWnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:43:51 -0500
Date: Thu, 18 Dec 2008 14:43:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Ciao <qingtao.cao@windriver.com>
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net,
       Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 1/1] EDAC: fix edac core deadlock when removing a device
Message-Id: <20081218144342.4f033416.akpm@linux-foundation.org>
In-Reply-To: <1229576958-8037-2-git-send-email-qingtao.cao@windriver.com>
References: <1229576958-8037-1-git-send-email-qingtao.cao@windriver.com>
	<1229576958-8037-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 13:09:18 +0800
Harry Ciao <qingtao.cao@windriver.com> wrote:

> To remove an edac device, all pending work must be complete. At that point, 
> it is safe to remove the edac_dev structure.
> 
> If the pending work is not properly cleared and proper care is not taken 
> when waiting for it's completion, the following stack trace result:
>
> ...
> 
> --- a/drivers/edac/edac_device.c
> +++ b/drivers/edac/edac_device.c
> @@ -394,6 +394,12 @@ static void edac_device_workq_function(struct work_struct *work_req)
>  
>  	mutex_lock(&device_ctls_mutex);
>  
> +	/* If we are being removed, bail out immediately */
> +	if (edac_dev->op_state == OP_OFFLINE) {
> +		mutex_unlock(&device_ctls_mutex);
> +		return;
> +	}
> +
>  	/* Only poll controllers that are running polled and have a check */
>  	if ((edac_dev->op_state == OP_RUNNING_POLL) &&
>  		(edac_dev->edac_check != NULL)) {
> @@ -585,14 +591,14 @@ struct edac_device_ctl_info *edac_device_del_device(struct device *dev)
>  	/* mark this instance as OFFLINE */
>  	edac_dev->op_state = OP_OFFLINE;
>  
> -	/* clear workq processing on this instance */
> -	edac_device_workq_teardown(edac_dev);
> -
>  	/* deregister from global list */
>  	del_edac_device_from_global_list(edac_dev);
>  
>  	mutex_unlock(&device_ctls_mutex);
>  
> +	/* clear workq processing on this instance */
> +	edac_device_workq_teardown(edac_dev);
> +
>  	/* Tear down the sysfs entries for this instance */
>  	edac_device_remove_sysfs(edac_dev);
>  

Is the change to edac_device_workq_function() necessary? 
edac_device_workq_teardown()'s call to cancel_delayed_work() will
ensure that edac_device_workq_function() isn't running.

Incidentally, edac_device_workq_teardown() is an open-coded
cancel_delayed_work_sync().

