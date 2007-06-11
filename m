Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbXFKRcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbXFKRcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXFKRcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:32:08 -0400
Received: from [198.99.130.12] ([198.99.130.12]:47946 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXFKRcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:32:07 -0400
Date: Mon, 11 Jun 2007 13:31:54 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UML: fix missing non-blocking I/O, now DEBUG_SHIRQ works
Message-ID: <20070611173154.GA6889@c2.user-mode-linux.org>
References: <1181512917.3157.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181512917.3157.8.camel@localhost>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 01:01:57AM +0300, Eduard-Gabriel Munteanu wrote:
> DEBUG_SHIRQ generates spurious interrupts, triggering handlers such as 
> mconsole_interrupt() or line_interrupt(). They expect data to be 
> available to be read from their sockets/pipes, but in the case of 
> spurious interrupts, the host didn't actually send anything, so UML 
> hangs in read() and friends. Setting those fd's as O_NONBLOCK makes 
> DEBUG_SHIRQ-enabled UML kernels boot and run correctly. 

Nice.

I don't really like this section though.  The casting I have now isn't
pleasant, but I don't like adding a new global to get rid of it.

> diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
> index 542c9ef..02d132e 100644
> --- a/arch/um/drivers/mconsole_kern.c
> +++ b/arch/um/drivers/mconsole_kern.c
> @@ -74,12 +74,11 @@ static DECLARE_WORK(mconsole_work, mc_work_proc);
>  
>  static irqreturn_t mconsole_interrupt(int irq, void *dev_id)
>  {
> -	/* long to avoid size mismatch warnings from gcc */
> -	long fd;
> +	int fd;
>  	struct mconsole_entry *new;
>  	static struct mc_request req;	/* that's OK */
>  
> -	fd = (long) dev_id;
> +	fd = *((int *) dev_id);
>  	while (mconsole_get_request(fd, &req)){
>  		if(req.cmd->context == MCONSOLE_INTR)
>  			(*req.cmd->handler)(&req);
> @@ -798,10 +797,10 @@ void mconsole_stack(struct mc_request *req)
>   */
>  static char *notify_socket = NULL;
>  
> +static int sock;
> +
>  static int mconsole_init(void)
>  {
> -	/* long to avoid size mismatch warnings from gcc */
> -	long sock;
>  	int err;
>  	char file[256];
>  
> @@ -818,7 +817,7 @@ static int mconsole_init(void)
>  
>  	err = um_request_irq(MCONSOLE_IRQ, sock, IRQ_READ, mconsole_interrupt,
>  			     IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
> -			     "mconsole", (void *)sock);
> +			     "mconsole", &sock);
>  	if (err){
>  		printk("Failed to get IRQ for management console\n");
>  		return(1);

				Jeff

-- 
Work email - jdike at linux dot intel dot com
