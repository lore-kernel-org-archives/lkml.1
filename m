Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbXENUx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbXENUx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXENUxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:53:49 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58704 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbXENUxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:53:48 -0400
Date: Mon, 14 May 2007 22:51:13 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Badari Pulavarty <pbadari@us.ibm.com>
cc: bharata@linux.vnet.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  5/14] Introduce union stack
In-Reply-To: <1179174187.2836.72.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.61.0705142248390.9570@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com>  <20070514094047.GG4139@in.ibm.com>
 <1179174187.2836.72.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 13:23, Badari Pulavarty wrote:
>> +static inline void union_lock_fs(struct fs_struct *fs)
>> +{
>> +	int locked;
>> +
>> +	while (fs) {
>> +		locked = union_trylock(fs->root);
>> +		if (!locked)
>> +			goto loop1;
>> +		locked = union_trylock(fs->altroot);
>> +		if (!locked)
>> +			goto loop2;
>> +		locked = union_trylock(fs->pwd);
>> +		if (!locked)
>> +			goto loop3;
>> +		break;
                ^^^^^^
>> +	loop3:
>> +		union_unlock(fs->altroot);
>> +	loop2:
>> +		union_unlock(fs->root);
>> +	loop1:
>> +		read_unlock(&fs->lock);
>> +		UM_DEBUG_LOCK("Failed to get all semaphores in fs_struct!\n");
>> +		cpu_relax();
>> +		read_lock(&fs->lock);
>> +		continue;
>
>Nit.. why "continue" ?

There's your break. Oh right, the continue is superfluous.

At the risk of using yet another goto, the conditional jump
could be turned into an inconditional one, since 'fs' will
remain valid. (Compiler smart enough to figure out?)

>> +	while (fs) {
	loop0:
>> +		locked = union_trylock(fs->root);
>> +		if (!locked)
>> +			goto loop1;
>> +		locked = union_trylock(fs->altroot);
>> +		if (!locked)
>> +			goto loop2;
>> +		locked = union_trylock(fs->pwd);
>> +		if (!locked)
>> +			goto loop3;
>> +		break;
>> +	loop3:
>> +		union_unlock(fs->altroot);
>> +	loop2:
>> +		union_unlock(fs->root);
>> +	loop1:
>> +		read_unlock(&fs->lock);
>> +		UM_DEBUG_LOCK("Failed to get all semaphores in fs_struct!\n");
>> +		cpu_relax();
>> +		read_lock(&fs->lock);
		/* continue */
		goto loop0;
	}


	Jan
-- 
