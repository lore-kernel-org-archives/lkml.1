Return-Path: <linux-kernel-owner+w=401wt.eu-S1762705AbZATUHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762705AbZATUHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbZATUH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:07:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:59055 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbZATUH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:07:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=X0dRo22TXnc4ONNEVXk/k+jzsoP1XDTaII9O29lJZwZoKZhyaXzYnhFbMV7hYZqFt
	aAZ0c2oXAExQzr+YcOyGQ==
Message-ID: <49762EF1.3000001@google.com>
Date: Tue, 20 Jan 2009 12:07:13 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 1/8] Deferred batching of dput()
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com> <20090117022942.20425.15217.stgit@crlf.corp.google.com> <20090117101501.GA2682@ioremap.net>
In-Reply-To: <20090117101501.GA2682@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.145
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Hi Mike.
> 
> On Fri, Jan 16, 2009 at 06:29:42PM -0800, Mike Waychison (mikew@google.com) wrote:
>> +static void postpone_dput(struct dentry *dentry)
>> +{
>> +	struct postponed_dentries *ppd, *new_ppd;
>> +
>> +again:
>> +	ppd = get_cpu_var(postponed_dentries);
>> +	if (!pending_dput_full(ppd)) {
>> +		add_pending_dput(ppd, dentry);
>> +		put_cpu_var(postponed_dentries);
>> +		return;
>> +	}
>> +
>> +	/* need to flush out existing pending dentries. */
>> +	put_cpu_var(postponed_dentries);
>> +	/* Allocate more space.. */
>> +	new_ppd = new_postponed_dentries();
>> +	if (!new_ppd) {
>> +		/* Take the slow path, memory is low */
>> +		struct postponed_dentries_onstack ppd_onstack;
>> +		struct postponed_dentries *ppd;
>> +
>> +		ppd = init_ppd_onstack(&ppd_onstack);
>> +		add_pending_dput(ppd, dentry);
>> +		process_postponed_dentries(ppd);
>> +		return;
>> +	}
> 
> Why don't you want just to put the dentry in the lowmem condition?
> 

You're right.  This path could just use the original dput path.  I'll 
fix it up in the next version.
