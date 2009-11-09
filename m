Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZKIP4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZKIP4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZKIP4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:56:11 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65166 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931AbZKIP4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:56:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=m5OtDqVKMRRHgVsn/drhV31Q2/gaq0sYKwgD5mgKWPtuHmXZwcSsfb2vdoT6PvVx4p
         833klvOeTS2pSQXwki9Oo5MBz2awQW6I7dw3TJH4tgrD2E0P8OiX+3pVtuuZnV5GxYR8
         OEcNZPieZsCcHJ1i8OK6xvxegO9tjcssHcbJg=
Message-ID: <4AF83B9A.60702@gmail.com>
Date: Mon, 09 Nov 2009 16:56:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits external
 to a process (v7)
References: <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain> <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu> <4AF7D8C2.60807@gmail.com> <20091109090143.GB24020@elte.hu>
In-Reply-To: <20091109090143.GB24020@elte.hu>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 10:01 AM, Ingo Molnar wrote:
> So i guess renaming setrlimit to do_setrlimit and adding the syscall 
> from Neil's patch should bring the two series into sync, right?

Actually, not really. It can't work for few reasons (below) now.

+SYSCALL_DEFINE3(getprlimit, pid_t, pid, unsigned int, resource,
+		struct rlimit __user *, rlim)
+{
+	unsigned long flags;
+	struct task_struct *tsk;
+	struct pid *ppid;
+	int retval = -EINVAL;

(here should be some sort of security checking as spotted by Ingo
already). And I would move the out-of-bounds resource check here as well
to reduce the fail path handling.

+	ppid = find_get_pid(pid);
+	if (!ppid)
+		goto out;
+
+	tsk = get_pid_task(ppid, PIDTYPE_PID);
+
+	if (!tsk)
+		goto out_put_pid;
+
+	if (resource >= RLIM_NLIMITS)
+		goto out_put_all;
+
+	retval = -EBUSY;
+	if (!lock_task_sighand(tsk, &flags))

X task_lock below cannot nest inside sighand (according to Oleg)
X ->sighand/signal might be NULL here (and below) AFAICT
So we need tasklist_lock for reading and check sighand != NULL.

+		goto out_put_all;
+
+	else {
+		struct rlimit val;
+
+		task_lock(tsk->group_leader);
+		val = current->signal->rlim[resource];

Well, you meant tsk->signal->rlim[resource] :).

+		task_unlock(tsk->group_leader);
+		retval = copy_to_user(rlim, &val, sizeof(*rlim)) ? -EFAULT : 0;
+	}

If I'm totally overlooking something, please let me know, otherwise I'll
fix that in the way I wrote above. (The same holds for setprlimit.)

Thanks.
