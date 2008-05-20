Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbYETSoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbYETSoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbYETSoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:44:13 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:37745 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbYETSoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:44:12 -0400
Subject: Re: [PATCH 2/4] pktgen: make sure that pktgen_thread_worker has
	been executed
From: "Denis V. Lunev" <den@openvz.org>
To: Robert Olsson <Robert.Olsson@data.slu.se>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
       Robert Olsson <robert.olsson@its.uu.se>,
       Ben Greear <greearb@candelatech.com>
In-Reply-To: <18483.6334.468166.282922@robur.slu.se>
References: <1211277589-8565-1-git-send-email-den@openvz.org>
	 <1211277589-8565-2-git-send-email-den@openvz.org>
	 <18483.6334.468166.282922@robur.slu.se>
Content-Type: text/plain
Organization: OpenVz kernel team
Date: Tue, 20 May 2008 22:43:42 +0400
Message-Id: <1211309022.7496.3.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-20 at 20:30 +0200, Robert Olsson wrote:
> Denis V. Lunev writes:
> 
>  > The problem is that pktgen_thread_worker can not be executed if kthread_stop
>  > has been called too early. Insert a completion on the normal initialization
>  > path to make sure that pktgen_thread_worker will gain the control for sure.
> 
> 
>  Yes how about if we move the wait_for_completion() to pg_cleanup before
>  we remove the threads. And move the complete() last in pktgen_thread_worker. 
>  This completion would sync with both start and stop.
> 
>  Cheers.
> 					--ro

you can't. The idea is to have a checkpoint _before_ khread_stop.
Currently you have a race between


static int kthread(void *_create)
{
   ...
   if (!kthread_should_stop())
       pktgen_thread_worker();
   ...
}

and kthread_stop. If kthread_stop will be called _before_ the control
goes inside pktgen_thread_worker you'll OOPS.

Regards,
	Den

