Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbYHCUDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbYHCUDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYHCUDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:03:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45616 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692AbYHCUDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:03:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-8-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-14-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-15-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-17-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-18-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-19-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-20-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-21-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-22-git-send-email-yhlu.kernel@gmail.com>
	<20080803161447.791705bb@lxorguk.ukuu.org.uk>
Date: Sun, 03 Aug 2008 12:57:23 -0700
In-Reply-To: <20080803161447.791705bb@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Sun, 3 Aug 2008 16:14:47 +0100")
Message-ID: <m1hca150t8.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3109]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 21/25] serial: change remove NR_IRQS in 8250.c v2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Sat,  2 Aug 2008 19:59:21 -0700
> Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> use small array with index to handle irq locking for serial port
>> hope 32 slot is enough
>
>
> Untested alternative approach

I like it.

Good catch on the m68k serial driver.


> 8250: Remove NR_IRQ usage
>
> From: Alan Cox <alan@redhat.com>

Now to pick a few nits ;)

You are short a definition of NR_IRQ_HASH that is trivial.

>
>  drivers/serial/68328serial.c |   11 ++---------
>  drivers/serial/8250.c        |   41 ++++++++++++++++++++++++++++++++++-------
>  2 files changed, 36 insertions(+), 16 deletions(-)


> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index a97f1ae..7165e88 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -145,11 +145,14 @@ struct uart_8250_port {
>  };
>  
>  struct irq_info {
> -	spinlock_t		lock;
> +	struct			irq_info *next;
	struct hlist_node	hchain;
Would allow us to use the generic hash table code.
> +	int			irq;
> +	spinlock_t		lock;	/* Protects list not the hash */
>  	struct list_head	*head;
>  };
>  
> -static struct irq_info irq_lists[NR_IRQS];
> +static struct irq_info *irq_lists[NR_IRQ_HASH];
> +static DEFINE_SPINLOCK(hash_lock);	/* Used to walk the hash */
static DEFINE_MUTEX(hash_mutex);

kzalloc sleeps....

Looks like we can also tweak serial_do_unlink to free irq_info when
the list goes empty, so we don't have a leak if the driver is ever
unloaded.

Eric
