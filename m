Return-Path: <linux-kernel-owner+w=401wt.eu-S936170AbYBCNI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936170AbYBCNI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 08:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934319AbYBCNIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 08:08:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45496 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764556AbYBCNIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 08:08:46 -0500
Date: Sun, 3 Feb 2008 13:08:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: section breakage on ppc64 (aka __devinitconst is broken by design)
Message-ID: <20080203130844.GS27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

; cat >a.c <<'EOF'
const char foo[] __attribute__ ((__section__(".blah"))) = "";
const char * const bar __attribute__((__section__(".blah"))) = "";
EOF
; gcc -m32 -S a.c
; gcc -m64 -S a.c
a.c:2: error: bar causes a section type conflict
;

That's 4.1.2 on ppc.  What happens is that the second declaration
wants to make .blah writable.  We actually trigger that in ppc64
builds on drivers/net/natsemi.c.

Note that on ppc64 without explicit sections you have the second one land in
.data.rel.ro.local, which is "aw",progbits.

The reason why it didn't visibly bite us before is that usually __devinit...
just expanded to nothing (unless you disable HOTPLUG, which requires
EMBEDDED, which wasn't apparently common enough for ppc64 builds).

Suggestions?
