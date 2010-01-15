Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab0AOPSH (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 10:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858Ab0AOPSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 10:18:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:53158 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab0AOPSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 10:18:02 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf symbols: The synthesized kernel modules MMAP must use the pathnames
Date: Fri, 15 Jan 2010 13:17:51 -0200
Message-Id: <1263568672-30323-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since we use ->long_name in dsos__find now.

Now 'perf buildid_list' is not duplicating those and managing to show
the proper build-ids for the DSOs with hits:

[root@doppio linux-2.6-tip]# perf buildid-list -H
74f9930ee94475b6b3238caf3725a50d59cb994b [kernel.kallsyms]
9ffdcac0a7935922d1f04b6cc9029dfef0f066ef /lib/modules/2.6.33-rc4-tip+/kernel/arch/x86/crypto/aes-x86_64.ko
3aaf89c32ebfc438ff546c93597d41788e3e65f3 /lib/modules/2.6.33-rc4-tip+/kernel/drivers/net/wireless/iwlwifi/iwl3945.ko
19f46033f73e1ec612937189bb118c5daba5a0c8 /lib/modules/2.6.33-rc4-tip+/kernel/net/mac80211/mac80211.ko
1772f014a7a7272859655acb0c64a20ab20b75ee /lib/modules/2.6.33-rc4-tip+/kernel/drivers/net/e1000e/e1000e.ko
eb4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1 /lib64/libc-2.10.2.so
5c68f7afeb33309c78037e374b0deee84dd441f6 /lib64/libpthread-2.10.2.so
e9c9ad5c138ef882e4507d2605645b597da43873 /bin/dbus-daemon
bcda7d09eb6c9ee380dae0ed3d591d4311decc31 /lib64/libdbus-1.so.3.4.0
7cc449a77f48b85d6088114000e970ced613bed8 /usr/lib64/libcrypto.so.0.9.8k
fdd1ccd1ff7917ab020653147ab3bacf0a85b5b9 /lib64/libglib-2.0.so.0.2000.5
e4417ebb8762e5f2eee93c8011a71115ff5edad8 /lib64/libgobject-2.0.so.0.2000.5
931e49461f6df99104f0febcc52f6fed5e2efce6 /usr/sbin/sshd
dab5f724c088f89fbd8304da553ed6cb30bbec96 /usr/lib64/libgdk-x11-2.0.so.0.1600.6
f2037a091ef36b591187a858d75e203690ea9409 /usr/sbin/openvpn
a8e4f743b40fb1fd8b85e2f9b88d93b661472b8f /bin/find
81120aada06e68b1e85882925a0fc6d7345ef59a /home/acme/bin/perf
[root@doppio linux-2.6-tip]#

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 5a6e827..966d207 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -345,15 +345,15 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 
 			map = perf_session__new_module_map(session,
 							   self->mmap.start,
-							   short_module_name);
+							   self->mmap.filename);
 			if (map == NULL)
 				goto out_problem;
 
-			name = strdup(self->mmap.filename);
+			name = strdup(short_module_name);
 			if (name == NULL)
 				goto out_problem;
 
-			dso__set_long_name(map->dso, name);
+			map->dso->short_name = name;
 			map->end = map->start + self->mmap.len;
 		} else if (memcmp(self->mmap.filename, kmmap_prefix,
 				sizeof(kmmap_prefix) - 1) == 0) {
-- 
1.6.2.5

