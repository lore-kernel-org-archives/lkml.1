Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbZATUH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbZATUH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762758AbZATUHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:07:47 -0500
Received: from smtp-out.google.com ([216.239.45.13]:59073 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbZATUHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:07:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=aoXPJkT9xbYczkk2sutWgj67dgdyZiSZuI+ZmdigkDSX4AzuB6MIsM0mjDEuIPCkb
	zgz6/YDyr3d81f0vFiPqg==
Message-ID: <49762F07.1050404@google.com>
Date: Tue, 20 Jan 2009 12:07:35 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 3/8] Deferred batching of iput()
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com> <20090117022952.20425.91639.stgit@crlf.corp.google.com> <20090117101809.GB2682@ioremap.net>
In-Reply-To: <20090117101809.GB2682@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.148
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Fri, Jan 16, 2009 at 06:29:52PM -0800, Mike Waychison (mikew@google.com) wrote:
>> +static void postpone_iput(struct inode *inode)
>> +{
>> +	struct postponed_inodes *ppi, *new_ppi;
>> +
>> +again:
>> +	ppi = get_cpu_var(postponed_inodes);
>> +	if (!pending_iput_full(ppi)) {
>> +		add_pending_iput(ppi, inode);
>> +		put_cpu_var(postponed_inodes);
>> +		return;
>> +	}
>> +
>> +	/* Need to flush out existing pending inodes */
>> +	put_cpu_var(postponed_inodes);
>> +	/* Allocate more space.. */
>> +	new_ppi = new_postponed_inodes();
>> +	if (!new_ppi) {
>> +		struct postponed_inodes_onstack ppi_onstack;
>> +
>> +		ppi = init_ppi_onstack(&ppi_onstack);
>> +		add_pending_iput(ppi, inode);
>> +		process_postponed_inodes(ppi);
>> +		return;
>> +	}
> 
> The same here: what just not to call a real_iput() without on-stack
> allocation and the line?
> 

Agreed.  Will fix in the next version.
