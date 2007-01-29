Return-Path: <linux-kernel-owner+w=401wt.eu-S1750875AbXA2KVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875AbXA2KVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXA2KVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:21:14 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:35469 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750875AbXA2KVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:21:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
  b=QgaoZHamm17cgDfauQno29qXbCy7TSxBvMpsUfphv+RmF0jyfgYAoESA9dtKr6VNMCWLsPIzbx+UbzlwHfIH7fce0B4BnqCb8UPNqb8VvwwG6CCm+rRiSmFzXBHKGnaGxkQNUteJjBTh/TD9u32Mbvngq4PyYr7kHuqvBgkXQxQ=  ;
X-YMail-OSG: AATuJlkVM1mtTd.UmQJt14Gh0BsbwA8y3bCaUAcgFm.v6.F1HtM3vgMlPWcdanL.D0W3i_goeHBhJCvWQCEKAMAe4DbBXKOOXBrmJLZL16wYxDM73rFbfyZnvu5pIzXQBhSDzLe1dDISdIE-
Message-ID: <45BDCA8A.4050809@yahoo.com.au>
Date: Mon, 29 Jan 2007 21:20:58 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       David Howells <dhowells@redhat.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@osdl.org>
Subject: page_mkwrite caller is racy?
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After do_wp_page calls page_mkwrite on its target (old_page), it then drops the
reference to the page before locking the ptl and verifying that the pte points
to old_page.

Unfortunately, old_page may have been truncated and freed, or reclaimed, then
re-allocated and used again for the same pagecache position and faulted in
read-only into the same pte by another thread. Then you will have a situation
where page_mkwrite succeeds but the page we use is actually a readonly one.

Moving page_cache_release(old_page) to below the next statement will fix that
problem.

But it is sad that this thing got merged without any callers to even know how it
is intended to work. Must it be able to sleep?

Nick

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
