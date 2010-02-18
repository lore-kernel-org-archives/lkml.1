Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0BRJis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:38:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab0BRJiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:38:46 -0500
Message-ID: <4B7D0A9E.9020507@redhat.com>
Date: Thu, 18 Feb 2010 09:38:38 +0000
From: Christine Caulfield <ccaulfie@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: David Teigland <teigland@redhat.com>
CC: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Cluster-devel] dlm: Remove/bypass astd
References: <1266413019.2907.27.camel@localhost> <20100217202920.GB29576@redhat.com>
In-Reply-To: <20100217202920.GB29576@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/10 20:29, David Teigland wrote:
> On Wed, Feb 17, 2010 at 01:23:39PM +0000, Steven Whitehouse wrote:
>>
>> While investigating Red Hat bug #537010 I started looking at the dlm's astd
>> thread. The way in which the "cast" and "bast" requests are queued looked
>> as if it might cause reordering since the "bast" requests are always
>> delivered after any pending "cast" requests which is not always the
>> correct ordering. This patch doesn't fix that bug, but it will prevent any
>> races in that bit of code, and the performance benefits are also well
>> worth having.
>>
>> I noticed that astd seems to be extraneous to requirements. The notifications
>> to astd are already running in process context, so they could be delivered
>> directly. That should improve smp performance since all the notifications
>> would no longer be funneled through a single thread.
>>
>> Also, the only other function of astd seemed to be stopping the delivery
>> of these notifications during recovery. Since, however, the notifications
>> which are intercepted at recovery time are neither modified, nor filtered
>> in any way, the only effect is to delay notifications for no obvious reason.
>>
>> I thought that probably removing the astd thread and delivering the "cast"
>> and "bast" notifications directly would improve performance due to the
>> elimination of a scheduling delay. I wrote a small test module which
>> creates a dlm lock space, and does 100,000 NL ->  EX ->  NL lock conversions.
>>
>> Having run this test 10 times each on a 2.6.33-rc8 kernel and then the modified
>> kernel including this patch, I got the following results:
>>
>> Original: Avg time 24.62 us per conversion (NL ->  EX ->  NL)
>> Modified: Avg time 9.93 us per conversion
>>
>> Which is a fairly dramatic speed up. Please consider applying this patch.
>> I've tested it in both clustered and single node GFS2 configurations. The test
>> figures are from a single node configuration which was a deliberate choice
>> in order to avoid any effects of network latency.
>
> Wow, there's no chance I'm going to even consider something like this.
> This would be a huge change in how the dlm has always operated, and would
> surely introduce very serious and hard to identify bugs (and ones that may
> not appear for a long time afterward).  Given that there's *no problem* with
> the current method that has worked well for years, any change would be
> completely crazy.

I think total dismissal of the idea is unreasonable. At least give it a 
chance, and test it for a while. Your argument is valid for not 
including it in a stable release as yet, but not for ignoring it 
completely.

Here we have a chance to remove some code, a kernel thread AND improve 
performance hugely. Just saying "it's always worked like that and we're 
not changing it" is the crazy argument IMHO.

Chrissie
