Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbZLXLzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbZLXLzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbZLXLzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:55:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:45737 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbZLXLzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:55:52 -0500
Message-ID: <4B3356A8.4020901@windriver.com>
Date: Thu, 24 Dec 2009 05:55:20 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu, mort@sgi.com,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 05/37] kdb: core for kgdb back end
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com> <1261603190-5036-2-git-send-email-jason.wessel@windriver.com> <1261603190-5036-3-git-send-email-jason.wessel@windriver.com> <1261603190-5036-4-git-send-email-jason.wessel@windriver.com> <1261603190-5036-5-git-send-email-jason.wessel@windriver.com> <1261603190-5036-6-git-send-email-jason.wessel@windriver.com> <1261652509.4937.185.camel@laptop>
In-Reply-To: <1261652509.4937.185.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Dec 2009 11:55:21.0425 (UTC) FILETIME=[F849B410:01CA848F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> On Wed, 2009-12-23 at 15:19 -0600, Jason Wessel wrote:
>   
>> diff --git a/kernel/module.c b/kernel/module.c
>> index e96b8ed..25f6a7b 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -79,6 +80,10 @@ EXPORT_TRACEPOINT_SYMBOL(module_get);
>>  DEFINE_MUTEX(module_mutex);
>>  EXPORT_SYMBOL_GPL(module_mutex);
>>  static LIST_HEAD(modules);
>> +#ifdef CONFIG_KGDB_KDB
>> +struct list_head *kdb_modules = &modules; /* kdb needs the list of
>> modules */
>> +#endif /* CONFIG_KGDB_KDB */
>> +
>>     

Above we export "modules" so that kdb can emulate lsmod.


The remainder was a port from the original kdb, and should not been
needed.  The preempt_disable and preempt_enable should be able to be
safely called while the system in the kgdb exception context, so this
chunk of code is going to get axed and re-tested.

Thanks,
Jason.

>>  
>>  /* Block module loading/unloading? */
>>  int modules_disabled = 0;
>> @@ -2654,8 +2659,14 @@ int module_get_kallsym(unsigned int symnum,
>> unsigned long *value, char *type,
>>                         char *name, char *module_name, int *exported)
>>  {
>>         struct module *mod;
>> +#ifdef CONFIG_KGDB_KDB
>> +       int get_lock = !KDB_IS_RUNNING();
>> +#else
>> +#define        get_lock 1
>> +#endif
>>  
>> -       preempt_disable();
>> +       if (get_lock)
>> +               preempt_disable();
>>         list_for_each_entry_rcu(mod, &modules, list) {
>>                 if (symnum < mod->num_symtab) {
>>                         *value = mod->symtab[symnum].st_value;
>> @@ -2664,12 +2675,14 @@ int module_get_kallsym(unsigned int symnum,
>> unsigned long *value, char *type,
>>                                 KSYM_NAME_LEN);
>>                         strlcpy(module_name, mod->name,
>> MODULE_NAME_LEN);
>>                         *exported = is_exported(name, *value, mod);
>> -                       preempt_enable();
>> +                       if (get_lock)
>> +                               preempt_enable();
>>                         return 0;
>>                 }
>>                 symnum -= mod->num_symtab;
>>         }
>> -       preempt_enable();
>> +       if (get_lock)
>> +               preempt_enable();
>>         return -ERANGE;
>>  }
>>     

