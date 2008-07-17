Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYGQMN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYGQMN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbYGQMNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:13:16 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50129 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951AbYGQMNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:13:15 -0400
X-Sasl-enc: vdnBknOX20DsOPJP53v4q3PESKnbcW3XDd1yeueX2Ged 1216296792
Date: Thu, 17 Jul 2008 09:13:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: alan-jenkins@tuffmail.co.uk, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other
	GPEs) on Asus EeePC
Message-ID: <20080717121309.GF31732@khazad-dum.debian.net>
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F31D7.30803@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487F31D7.30803@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Alexey Starikovskiy wrote:
> Thanks for the patch, ACK.

This one fixes a potentially bad problem, since we could ignore more than
just hot key EC events by accident.  Maybe it should go to -stable?

> Alan Jenkins wrote:
>> It looks like this EC clears the SMI_EVT bit after every query, even if there
>> are more events pending.  The workaround is to repeatedly query the EC until
>> it reports that no events remain.
>>
>> This fixes a regression in 2.6.26 (from 2.6.25.3).  Initially reported as
>> "Asus Eee PC hotkeys stop working if pressed quickly" in bugzilla
>> <http://bugzilla.kernel.org/show_bug.cgi?id=11089>.
>>
>> The regression was caused by a recently added check for interrupt storms.
>> The Eee PC triggers this check and switches to polling.  When multiple events
>> arrive between polling intervals, only one is fetched from the EC.  This causes
>> erroneous behaviour; ultimately events stop being delivered altogether when the
>> EC buffer overflows.
>>
>> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>>
>> ---
>> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
>> index 5622aee..2b4c5a2 100644
>> --- a/drivers/acpi/ec.c
>> +++ b/drivers/acpi/ec.c
>> @@ -459,14 +459,10 @@ void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
>>   EXPORT_SYMBOL_GPL(acpi_ec_remove_query_handler);
>>  -static void acpi_ec_gpe_query(void *ec_cxt)
>> +static void acpi_ec_gpe_run_handler(struct acpi_ec *ec, u8 value)
>>  {
>> -	struct acpi_ec *ec = ec_cxt;
>> -	u8 value = 0;
>>  	struct acpi_ec_query_handler *handler, copy;
>>  -	if (!ec || acpi_ec_query(ec, &value))
>> -		return;
>>  	mutex_lock(&ec->lock);
>>  	list_for_each_entry(handler, &ec->list, node) {
>>  		if (value == handler->query_bit) {
>> @@ -484,6 +480,18 @@ static void acpi_ec_gpe_query(void *ec_cxt)
>>  	mutex_unlock(&ec->lock);
>>  }
>>  +static void acpi_ec_gpe_query(void *ec_cxt)
>> +{
>> +	struct acpi_ec *ec = ec_cxt;
>> +	u8 value = 0;
>> +
>> +	if (!ec)
>> +		return;
>> +
>> +	while (!acpi_ec_query(ec, &value))
>> +		acpi_ec_gpe_run_handler(ec, value);
>> +}
>> +
>>  static u32 acpi_ec_gpe_handler(void *data)
>>  {
>>  	acpi_status status = AE_OK;

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
