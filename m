Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbYKFVqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbYKFVqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYKFVq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:46:29 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55821 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYKFVq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:46:28 -0500
To: akpm@linux-foundation.org
Cc: takedakn@nttdata.co.jp, haradats@nttdata.co.jp,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 06/11] Common functions for TOMOYOLinux.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20081104060847.086543472@nttdata.co.jp>
	<20081104060951.618445959@nttdata.co.jp>
	<20081105151221.d605226f.akpm@linux-foundation.org>
In-Reply-To: <20081105151221.d605226f.akpm@linux-foundation.org>
Message-Id: <200811070646.CJJ60437.FMOLJQHFSOtVFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 7 Nov 2008 06:46:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:
> (That's two hours of tomoyo-reading for me.  I need to stop now)
Thank you very much for reviewing.
Before I answer for individual comments, I'd like to show three basic outlines.

(1) The way TOMOYO handles string data.

To be able to handle any characters correctly, TOMOYO Linux follows the rules
shown below to represent a word. A word means all tokens that are treated as
string data, such as pathnames and comments.

 * NUL character (0x00) is used for indicating end of string.
   Thus you cannot include \000 in a word.
 * \ character (0x5C) is used for indicating octal expression.
   Thus, you need to use \\ to represent a \.
 * Characters 0x01 - 0x20 and 0x7F - 0xFF are represented using octal
   expression \ooo .
 * The rest characters (i.e. 0x21 - 0x5B and 0x5D - 0x7E) are represented
   as is.

 * Space character (0x20) is used as a delimiter that separates words.
   Line feed character (0x0A) is used as a delimiter that separates lines.
 * Only words that follow the rule above and the delimiters (i.e. space
   character and line feed characters) are valid. All other characters are
   regarded as space character. Multiple spaces are automatically compressed
   into one space. Leading and trailing spaces are automatically deleted.

(2) The way TOMOYO allocates memory.

In TOMOYO Linux, memory allocated for holding access permissions and words are
never freed. There is no way except rebooting the system that can free unneeded
memory.

But don't worry. The policy seldom changes after you start production mode.
By tuning policy before starting production mode, you can reduce memory usage
to (usually) less than 1 Mega Bytes. You can also enable memory quota.

(3) The kernel-userspace interface of TOMOYO.

Policy files are automatically loaded into the kernel upon boot.
When a system boots, /sbin/init is executed. When the execution of /sbin/init
is requested and if /sbin/tomoyo-init exists, /sbin/tomoyo-init is executed,
and /sbin/init is executed after /sbin/tomoyo-init terminates.
/sbin/tomoyo-init is called only once.

TOMOYO requires no modifications of existing userland applications.
The pathname /sbin/tomoyo-init is embedded into the kernel so that we don't
need to modify /sbin/init for loading policy.

/sbin/tomoyo-init loads policy via /sys/kernel/security/tomoyo/ interface.
All data passed through this interface consists of only ASCII printable
characters, for all words consist of only ASCII printable characters.

Regards.
