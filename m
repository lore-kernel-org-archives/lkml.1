Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab0BECMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 21:12:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52572 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab0BECMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 21:12:41 -0500
Message-ID: <4B6B7EA8.4070104@cn.fujitsu.com>
Date: Fri, 05 Feb 2010 10:12:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/13] net: simplify seq_file code
References: <4B6B77FE.5000104@cn.fujitsu.com>	<4B6B780D.10003@cn.fujitsu.com> <20100204175828.51b9e8a1.akpm@linux-foundation.org>
In-Reply-To: <20100204175828.51b9e8a1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 05 Feb 2010 09:44:45 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> +struct hlist_node *seq_hlist_start(struct hlist_head *head, loff_t pos)
>> +{
>> +	struct hlist_node *node;
>> +
>> +	hlist_for_each(node, head)
>> +		if (pos-- == 0)
>> +			return node;
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL(seq_hlist_start);
>> +
>> +struct hlist_node *seq_hlist_start_head(struct hlist_head *head, loff_t pos)
>> +{
>> +	if (!pos)
>> +		return SEQ_START_TOKEN;
>> +
>> +	return seq_hlist_start(head, pos - 1);
>> +}
>> +EXPORT_SYMBOL(seq_hlist_start_head);
>> +
>> +struct hlist_node *seq_hlist_next(void *v, struct hlist_head *head,
>> +				  loff_t *ppos)
>> +{
>> +	struct hlist_node *node = v;
>> +
>> +	++*ppos;
>> +	if (v == SEQ_START_TOKEN)
>> +		return head->first;
>> +	else
>> +		return node->next;
>> +}
>> +EXPORT_SYMBOL(seq_hlist_next);
> 
> Oy.  Most of the global functions in seq_file.c are kerneldocumented,
> as they should be!
> 

I'll add kerneldoc in v2 patchset if I have to resend, otherwise I'll
send a delta patch for this.

> Shouldn't seq_hlist_start_head() have been called seq_hlist_prev()?
> 

The list_head version has the name seq_list_start_head().

If you need to print a title in a seq_file, call seq_list_start_head()
in ->start() handler, otherwise call seq_list_start().

Those functions really need kerneldoc. ;)

> Should seq_hlist_start() be passed *ppos, and update *ppos so the
> caller can then call seq_hlist_next() and seq_hlist_prev()?
> 

No, the ->start() callback of seq_operations shouldn't update *ppos.
I fixed some bugs in ftrace debugfs files which were caused by
updating *ppos in start().

