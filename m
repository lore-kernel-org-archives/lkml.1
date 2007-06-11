Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbXFKTkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbXFKTkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXFKTkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:40:00 -0400
Received: from max.aladin.ro ([80.96.155.2]:32910 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbXFKTj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:39:59 -0400
Message-ID: <466DA50C.5050301@aladin.ro>
Date: Mon, 11 Jun 2007 22:39:56 +0300
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UML: fix missing non-blocking I/O, now DEBUG_SHIRQ
 works
References: <1181512917.3157.8.camel@localhost> <20070611173154.GA6889@c2.user-mode-linux.org>
In-Reply-To: <20070611173154.GA6889@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
Jeff Dike wrote:
> I don't really like this section though.  The casting I have now isn't
> pleasant, but I don't like adding a new global to get rid of it.
> 
>> diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
>> index 542c9ef..02d132e 100644
>> --- a/arch/um/drivers/mconsole_kern.c
>> +++ b/arch/um/drivers/mconsole_kern.c
>> @@ -74,12 +74,11 @@ static DECLARE_WORK(mconsole_work, mc_work_proc);
>>  
>>  static irqreturn_t mconsole_interrupt(int irq, void *dev_id)
>>  {
>> -	/* long to avoid size mismatch warnings from gcc */
>> -	long fd;
>> +	int fd;
>>  	struct mconsole_entry *new;
>>  	static struct mc_request req;	/* that's OK */
>>  
>> -	fd = (long) dev_id;
>> +	fd = *((int *) dev_id);
>>  	while (mconsole_get_request(fd, &req)){
>>  		if(req.cmd->context == MCONSOLE_INTR)
>>  			(*req.cmd->handler)(&req);
>> @@ -798,10 +797,10 @@ void mconsole_stack(struct mc_request *req)
>>   */
>>  static char *notify_socket = NULL;
>>  
>> +static int sock;
>> +
>>  static int mconsole_init(void)
>>  {
>> -	/* long to avoid size mismatch warnings from gcc */
>> -	long sock;
>>  	int err;
>>  	char file[256];
>>  
>> @@ -818,7 +817,7 @@ static int mconsole_init(void)
>>  
>>  	err = um_request_irq(MCONSOLE_IRQ, sock, IRQ_READ, mconsole_interrupt,
>>  			     IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
>> -			     "mconsole", (void *)sock);
>> +			     "mconsole", &sock);
>>  	if (err){
>>  		printk("Failed to get IRQ for management console\n");
>>  		return(1);
> 
> 				Jeff
> 

No offense, but this is an ugly hack. What if sizeof(int) != 
sizeof(long)? You're calling glibc functions with that fd as a 
parameter. On some arches, compiling will issue warnings or simply fail.

An alternative would be to use kmalloc instead of a global static 
variable. Do you like this one more?
