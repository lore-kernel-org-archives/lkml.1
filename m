Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbYC3IPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbYC3IPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 04:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYC3IP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 04:15:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:44787 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYC3IPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 04:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XuiOL8kcwzmwINGrXUpS7Y476uBHdG4feHrKE9DCmojvaSWvagyFMGrCmhQukqYKSLF5snSfoOcdzS77udlXzfnHPtVtt+r2NlJIMLeIlOQOKa7+iIP9dhjFGmXppvqM8IIC+zgneYCbQBd3U+Mswoaz92fWuglQFJ9H9ZUvbwg=
Message-ID: <86802c440803300115w6f3cc08cha72d3dc20bc4ec8e@mail.gmail.com>
Date: Sun, 30 Mar 2008 01:15:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 2/4] x86_64 boot -v2: Add linked list of struct setup_data
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, "Paul Jackson" <pj@sgi.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1206672584.13404.25.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206672584.13404.25.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 7:49 PM, Huang, Ying <ying.huang@intel.com> wrote:
> This patch add a field of 64-bit physical pointer to NULL terminated
>  single linked list of struct setup_data to real-mode kernel
>  header. This is used as a more extensible boot parameters passing
>  mechanism.
>
>  Signed-off-by: Huang Ying <ying.huang@intel.com>
>
>  ---
>   arch/x86/boot/header.S      |    6 +++++-
>   arch/x86/kernel/head64.c    |   20 ++++++++++++++++++++
>   arch/x86/kernel/setup_64.c  |   22 ++++++++++++++++++++++
>   include/asm-x86/bootparam.h |   14 ++++++++++++++
>   4 files changed, 61 insertions(+), 1 deletion(-)
>
...
>  +static void __init reserve_setup_data(void)
>  +{
>  +       struct setup_data *data;
>  +       unsigned long pa_data;
>  +       char buf[32];
>  +
>  +       if (boot_params.hdr.version < 0x0209)
>  +               return;
>  +       pa_data = boot_params.hdr.setup_data;
>  +       while (pa_data) {
>  +               data = early_ioremap(pa_data, sizeof(*data));
>  +               sprintf(buf, "setup data %x", data->type);
>  +               reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
>  +               pa_data = data->next;
>  +               early_iounmap(data, sizeof(*data));
>  +       }

current reserve_early will have limitation with 20 entries.

/*
 * Early reserved memory areas.
 */

#define MAX_EARLY_RES 20

or we need to make reserve_early a little bit smart, so it could merge
continuous region...
and then your free_early need to be updated too.

YH
