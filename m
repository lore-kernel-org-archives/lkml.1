Return-Path: <linux-kernel-owner+w=401wt.eu-S1764531AbXHPJ1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764531AbXHPJ1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 05:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXHPJ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 05:27:43 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:36296 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbXHPJ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 05:27:42 -0400
Message-ID: <46C4184B.5030303@ah.jp.nec.com>
Date: Thu, 16 Aug 2007 18:26:35 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: Keith Owens <kaos@ocs.com.au>, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
References: <20070802112852.GA7054@in.ibm.com> <31687.1186113947@kao2.melbourne.sgi.com> <20070805110746.GA12540@in.ibm.com> <46C1691E.7090708@ah.jp.nec.com> <20070814083710.GA14538@suse.de> <20070814132454.GA8293@in.ibm.com>
In-Reply-To: <20070814132454.GA8293@in.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
 > So for the time being I think we can put RAS tools on die notifier list
> and if it runs into issues we can always think of creating a separate list.
> 
> Few things come to mind.
> 
> - Why there is a separate panic_notifier_list? Can't it be merged with
>   die_chain? die_val already got one of the event type as PANIC. If there
>   are no specific reasons then we should merge the two lists. Registering
>   RAS tools on a single list is easier.

I think it is difficult, because die_chain is defined by each architecture.

> - Modify Kdump to register on die_chain list. 
> - Modify Kdb to register on die_chain list.
> - Export all the registered members of die_chain through sysfs along with
>   their priorities. Priorities should be modifiable. Most likely one 
>   shall have to introduce additional field in struct notifier_block. This
>   field will be a string as an identifier of the user registerd. e.g
>   "Kdump", "Kdb" etc.
> 
> Now user will be able to view all the die_chain users through sysfs and
> be able to modify the order in which these should run by modifying their
> priority. Hence all the RAS tools can co-exist.

This is my image of your proposal.

- Print current order

# cat /sys/class/misc/debug/panic_notifier_list
priority   name
1          IPMI
2          watchdog
3          Kdb
4          Kdump

- change list order

# echo <before> <after> > /sys/class/debug/panic_notifier_list

- example

# cat /sys/class/misc/debug/panic_notifier_list
priority   name
1          IPMI
2          watchdog
3          Kdb
4          Kdump

# echo 4 1 > /sys/class/debug/panic_notifier_list
priority   name
1          Kdump
2          IPMI
3          watchdog
4          Kdb


Is my image almost same as your thought?

Thanks
