Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508Ab0AELtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0AELtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041Ab0AELth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:49:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36340 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0AELtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:49:35 -0500
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/9] SYSCTL: Use RCU strings for core_pattern sysctl
From: Andi Kleen <andi@firstfloor.org>
References: <20100105315.789846878@firstfloor.org>
	<20100105021529.205EFB17C2@basil.firstfloor.org>
	<m1zl4t82f8.fsf@fess.ebiederm.org>
Date: Tue, 05 Jan 2010 12:49:34 +0100
In-Reply-To: <m1zl4t82f8.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Mon, 04 Jan 2010 22:56:59 -0800")
Message-ID: <87aawsdb5d.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:
>>  
>> @@ -1421,7 +1421,7 @@ EXPORT_SYMBOL(set_binfmt);
>>  static int format_corename(char *corename, long signr)
>>  {
>>  	const struct cred *cred = current_cred();
>> -	const char *pat_ptr = core_pattern;
>> +	const char *pat_ptr = rcu_dereference(core_pattern);
>
> rcu_dereference should aways be between rcu_read_lock()
> and rcu_read_unlock();

It is, see the call site below:

>> -	 * lock_kernel() because format_corename() is controlled by sysctl, which
>> -	 * uses lock_kernel()
>> +	 * Protect corename by RCU vs proc_rcu_string()
>>  	 */
>> - 	lock_kernel();
>> +	rcu_read_lock();
>>  	ispipe = format_corename(corename, signr);
>> -	unlock_kernel();
>> +	rcu_read_unlock();

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
