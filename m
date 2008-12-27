Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYL0FQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYL0FQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 00:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYL0FQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 00:16:21 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:45041 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYL0FQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 00:16:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dpaQMe48yvAj9A3IX6ia8rSM/NrgbrfyvZM4WYdSa9wD5+oDWhY4TC0huku3v7H91h
         LdsdR85w0+zk30slPJSptNjT5Pr1oHrZi/BXoPZ5UDkvqEnLsSdaQ87GvBeX/Vbp005Z
         ea8tIudj1A+sBcjFG46KDlTpKNg0qNshLAY/Q=
Date: Sat, 27 Dec 2008 14:16:08 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/4] x86: fix free_thread_info() with uninitalized
	thread_info
Message-ID: <20081227051606.GA3295@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes a problem described below. The actual fix is only
made by the patch 3/4. The rest of patches help it make simple and there
is no actual behavioral change.

x86 arch specific free_thread_info() accesses thread_info->task to call
free_thread_xstate(). But the thread_info may not be initialized yet.
So invalid pointer derefence may happen in free_thread_xstate().

It happens in the following scenario in dup_task_struct()

1. call alloc_task_struct() to allocate empty task_struct
2. call alloc_thread_info() to allocate empty thread_info
3. call arch_dup_task_struct()

x86 arch specific arch_dup_task_struct() copies task_struct from source
task_struct. it also allocates empty xstate and copy from source if
source task_struct has ->thread.xstate.

If the xstate allocation failed, arch_dup_task_struct() returns error.

4. call free_thread_info() to deallocate thread_info

x86 arch specific free_thread_info() calls free_thread_xstate() with
thread_info->task. But the thread_info is not initialized yet.

