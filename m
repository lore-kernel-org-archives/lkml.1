Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384Ab0ALC1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0ALC1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775Ab0ALC1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:27:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab0ALC1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:27:01 -0500
Message-ID: <4B4BDD7B.2070308@redhat.com>
Date: Tue, 12 Jan 2010 10:24:59 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <damm@igel.co.jp>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Xiaotian Feng <dfeng@redhat.com>, stable@kernel.org
Subject: Re: [PATCH] clockevent: don't remove broadcast device when cpu is
 dead
References: <1262834564-13033-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1262834564-13033-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

     Any comments on the patch? Marc confirmed this patch also fixed his 
hang at suspend/resume stage. Thanks.

     (Cc'ed stable@kernel.org)

Regards
Xiaotian

On 01/07/2010 11:22 AM, Xiaotian Feng wrote:
> Marc reported BUG during shutdown, after debugging, kernel is trying
> to remove a broadcast device which mode is CLOCK_EVT_MODE_ONESHOT.
>
> The root cause for this bug is that in clockevents_notify,
> "cpumask_weight(dev->cpumask) == 1" is always true even if dev is a
> broadcast device. We need to use tick_is_broadcast_device to check
> if it is a broadcast device.
>
> Reported-by: Marc Dionne<marc.c.dionne@gmail.com>
> Tested-by: Marc Dionne<marc.c.dionne@gmail.com>
> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Magnus Damm<damm@igel.co.jp>
> Cc: H Hartley Sweeten<hsweeten@visionengravers.com>
> ---
>   kernel/time/clockevents.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 6f740d9..0223d83 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -259,7 +259,7 @@ void clockevents_notify(unsigned long reason, void *arg)
>   		cpu = *((int *)arg);
>   		list_for_each_entry_safe(dev, tmp,&clockevent_devices, list) {
>   			if (cpumask_test_cpu(cpu, dev->cpumask)&&
> -			    cpumask_weight(dev->cpumask) == 1) {
> +			    !tick_is_broadcast_device(dev)) {
>   				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
>   				list_del(&dev->list);
>   			}
>    

