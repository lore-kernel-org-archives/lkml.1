Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYAJRZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYAJRZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 12:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758701AbYAJRYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 12:24:55 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42209 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbYAJRYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 12:24:52 -0500
Message-ID: <478654E1.5050501@bull.net>
Date: Thu, 10 Jan 2008 18:24:49 +0100
From: Benjamin Thery <benjamin.thery@bull.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: ebiederm@xmission.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PROCFS] [NETNS] issue with /proc/net entries
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/01/2008 18:33:06,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/01/2008 18:33:08,
	Serialize complete at 10/01/2008 18:33:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

While testing the current network namespace stuff merged in net-2.6.25,
I bumped into the following problem with the /proc/net/ entries.
It doesn't always display the actual data of the current namespace,
but sometime displays data from other namespaces.

I bisected the problem to the commit:
"proc: remove/Fix proc generic d_revalidate"
3790ee4bd86396558eedd86faac1052cb782e4e1

The problem: If a process in a particular network namespace changes
current directory to /proc/net, then processes in other network
namespaces trying to look at /proc/net entries will see data from the
first namespace (the one with CWD /proc/net). (See test case below).

As you comments in the commit suggest, you seem to be aware of some
issues when CONFIG_NET_NS=y. Is it one of these corner cases you
identified? Any idea on how we can fix it?

Thanks.

Benjamin


Test case:
----------
(1) Shell 1, in init namespace:
$ cat /proc/net/dev
lo ...
eth0 ...

(2) Shell 2, in another network namespace
$ cat /proc/net/dev
lo ...

(3) Shell 1
$ cd /proc/net
$ cat dev
lo ...
eth0 ...

(4) Shell 2
$ cat /proc/net/dev
lo ...
eth0 ...

Argh, lo + eth0 in child namespace.... the device list of init netns
is displayed in /proc/net/dev of child namespace :-(

(5) Shell 1
$ cd /

(6) Shell 2
$ cat /proc/net/dev
lo ...

Back to normality.


-- 
B e n j a m i n   T h e r y  - BULL/DT/Open Software R&D

    http://www.bull.com
