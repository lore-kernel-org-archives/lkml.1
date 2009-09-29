Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZI2C2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZI2C2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 22:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZI2C2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 22:28:45 -0400
Received: from adelie.canonical.com ([91.189.90.139]:38674 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZI2C2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 22:28:44 -0400
Message-ID: <4AC170DA.3000907@canonical.com>
Date: Tue, 29 Sep 2009 10:28:42 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alexey Starikovskiy <aystarik@gmail.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Add EC event managerment functions into header
 file
References: <1254173448-18362-1-git-send-email-ike.pan@canonical.com> <4AC135AC.2010407@gmail.com>
In-Reply-To: <4AC135AC.2010407@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had sent a new driver for Lenovo SL series laptops [1], and it uses those
functions to detect hotkeys. Since it has been exported for other modules,
I think it is reasonable to write in header file to make sure everyone has
the same definition.

[1] http://patchwork.kernel.org/patch/49912/

Alexey Starikovskiy wrote:
> These functions are never used anywhere, but sbshc.c.
> What is the reason to make them known to the whole kernel?
> 
> Ike Panhc пишет:
>> There are two functions for add/remove EC query handler functions, which
>> exported without any definition in header files
>>
>> Patch against current checkout of linux-acpi 2.6.31 is below.
>>
>> In this patch, the following definitions has been added into
>> include/linux/acpi.h
>>  - typedef: acpi_ec_query_func
>>  - struct: acpi_ec
>>  - fucntions: acpi_ec_add_query_handler, acpi_ec_remove_query_handler
>>
>> And the following definitions has been removed from driver/acpi/ec.c
>>  - typedef: acpi_ec_query_func
>>  - struct: acpi_ec
>>
>> So that, the following externs and typedef could be remove from
>> drivers/acpi/sbshc.c
>>  - typedef: acpi_ec_query_func
>>  - externs: acpi_ec_add_query_handler, acpi_ec_remove_query_handler
>>
>> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
>> ---
>>  drivers/acpi/ec.c    |   22 +++++-----------------
>>  drivers/acpi/sbshc.c |    8 --------
>>  include/linux/acpi.h |   21 +++++++++++++++++++++
>>  3 files changed, 26 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
>> index f707960..8950c4f 100644
>> --- a/drivers/acpi/ec.c
>> +++ b/drivers/acpi/ec.c
>> @@ -43,6 +43,7 @@
>>  #include <acpi/acpi_bus.h>
>>  #include <acpi/acpi_drivers.h>
>>  #include <linux/dmi.h>
>> +#include <linux/acpi.h>
>>  
>>  #define ACPI_EC_CLASS            "embedded_controller"
>>  #define ACPI_EC_DEVICE_NAME        "Embedded Controller"
>> @@ -80,10 +81,6 @@ enum {
>>                       * OpReg are installed */
>>  };
>>  
>> -/* If we find an EC via the ECDT, we need to keep a ptr to its
>> context */
>> -/* External interfaces use first EC only, so remember */
>> -typedef int (*acpi_ec_query_func) (void *data);
>> -
>>  struct acpi_ec_query_handler {
>>      struct list_head node;
>>      acpi_ec_query_func func;
>> @@ -104,19 +101,10 @@ struct transaction {
>>      bool done;
>>  };
>>  
>> -static struct acpi_ec {
>> -    acpi_handle handle;
>> -    unsigned long gpe;
>> -    unsigned long command_addr;
>> -    unsigned long data_addr;
>> -    unsigned long global_lock;
>> -    unsigned long flags;
>> -    struct mutex lock;
>> -    wait_queue_head_t wait;
>> -    struct list_head list;
>> -    struct transaction *curr;
>> -    spinlock_t curr_lock;
>> -} *boot_ec, *first_ec;
>> +/* If we find an EC via the ECDT, we need to keep a ptr to its
>> context */
>> +/* External interfaces use first EC only, so remember */
>> +static struct acpi_ec *boot_ec;
>> +static struct acpi_ec *first_ec;
>>  
>>  static int EC_FLAGS_MSI; /* Out-of-spec MSI controller */
>>  
>> diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
>> index d933980..d5550a5 100644
>> --- a/drivers/acpi/sbshc.c
>> +++ b/drivers/acpi/sbshc.c
>> @@ -250,12 +250,6 @@ static int smbus_alarm(void *context)
>>      return 0;
>>  }
>>  
>> -typedef int (*acpi_ec_query_func) (void *data);
>> -
>> -extern int acpi_ec_add_query_handler(struct acpi_ec *ec, u8 query_bit,
>> -                  acpi_handle handle, acpi_ec_query_func func,
>> -                  void *data);
>> -
>>  static int acpi_smbus_hc_add(struct acpi_device *device)
>>  {
>>      int status;
>> @@ -292,8 +286,6 @@ static int acpi_smbus_hc_add(struct acpi_device
>> *device)
>>      return 0;
>>  }
>>  
>> -extern void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8
>> query_bit);
>> -
>>  static int acpi_smbus_hc_remove(struct acpi_device *device, int type)
>>  {
>>      struct acpi_smb_hc *hc;
>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
>> index dfcd920..259eacb 100644
>> --- a/include/linux/acpi.h
>> +++ b/include/linux/acpi.h
>> @@ -145,12 +145,33 @@ struct acpi_pci_driver {
>>  int acpi_pci_register_driver(struct acpi_pci_driver *driver);
>>  void acpi_pci_unregister_driver(struct acpi_pci_driver *driver);
>>  
>> +typedef int (*acpi_ec_query_func) (void *data);
>> +
>> +struct acpi_ec {
>> +    acpi_handle handle;
>> +    unsigned long gpe;
>> +    unsigned long command_addr;
>> +    unsigned long data_addr;
>> +    unsigned long global_lock;
>> +    unsigned long flags;
>> +    struct mutex lock;
>> +    wait_queue_head_t wait;
>> +    struct list_head list;
>> +    struct transaction *curr;
>> +    spinlock_t curr_lock;
>> +};
>> +
>>  extern int ec_read(u8 addr, u8 *val);
>>  extern int ec_write(u8 addr, u8 val);
>>  extern int ec_transaction(u8 command,
>>                            const u8 *wdata, unsigned wdata_len,
>>                            u8 *rdata, unsigned rdata_len,
>>                int force_poll);
>> +extern int acpi_ec_add_query_handler(struct acpi_ec *ec, u8 query_bit,
>> +                      acpi_handle handle,
>> +                      acpi_ec_query_func func, void *data);
>> +extern void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8
>> query_bit);
>> +
>>  
>>  #if defined(CONFIG_ACPI_WMI) || defined(CONFIG_ACPI_WMI_MODULE)
>>  
>>   
> 
> 


-- 
Ike Panhc <ike.pan@canonical.com>
Hardware Enable Team - Kernel Team - Platform Team - Canonical
Ubuntu - Linux for human beings | www.ubuntu.com | www.canonical.com
