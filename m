Return-Path: <linux-kernel-owner+w=401wt.eu-S965884AbXCFOkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965884AbXCFOkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965105AbXCFOkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:40:09 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:42636 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965884AbXCFOkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:40:07 -0500
Message-ID: <45ED7DEC.7010403@sw.ru>
Date: Tue, 06 Mar 2007 17:42:52 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
CC: devel@openvz.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org, Kirill Korotaev <dev@sw.ru>
Subject: [RFC][PATCH 0/7] Resource controllers based on process containers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds RSS, accounting and control and
limiting the number of tasks and files within container.

Based on top of Paul Menage's container subsystem v7

RSS controller includes per-container RSS accounter,
reclamation and OOM killer. It behaves like standalone
machine - when container runs out of resources it tries
to reclaim some pages and if it doesn't succeed in it
kills some task which mm_struct belongs to container in
question.

Num tasks and files containers are very simple and
self-descriptive from code.

As discussed before when a task moves from one container
to another no resources follow it - they keep holding the
container they were allocated in.

The difficulties met during using of Pauls' containers were:

1. Container fork hook is placed before new task
   changes. This makes impossible of handling fork
   properly. I.e. new mm_struct should have pointer
   to RSS container, but we don't have one at that
   early time.

2. Extended containers may register themselves too late.
   Kernel threads/helpers start forking, opening files
   and touching pages much earlier. This patchset
   workarounds this in not-so-cute manner and I'm waiting
   for Paul's comments on this issue.
