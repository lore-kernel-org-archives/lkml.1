Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYCNXOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYCNXOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 19:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYCNXOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 19:14:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:57159 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYCNXOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 19:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=rzfuxSLOY5JEUzqeaYyRLcZxNqbnRSWNizqNpBi3od9YiLNHDbVPVKafRJwsm/sLfqxGbJnpzBxEnjH9gUU1XssgxFwbyTdXki7AzimwXBm2eoXqpXAK3Jm4axbR/VEoudnvS3l4fF2C5AsKlFVB3UbY/a4pRGjNAxK20NAqRhU=
Date: Sat, 15 Mar 2008 01:10:34 +0200
To: Casey Schaufler <casey@schaufler-ca.com>, akpm <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH BUGFIX -rc5] Smack: Do not dereference NULL ipc object
Message-ID: <20080314231034.GA1701@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In the SYSV ipc msgctl(),semctl(),shmctl() family, if the user passed
*_INFO as the desired operation, no specific object is meant to be 
controlled and only system-wide information is returned. This leads
to a NULL IPC object in the LSM hooks if the _INFO flag is given.

Avoid dereferencing this NULL pointer in Smack ipc *ctl() methods.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 smack_lsm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0241fd3..38d7075 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1508,7 +1508,7 @@ static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
  */
 static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
 {
-	char *ssp = smack_of_shm(shp);
+	char *ssp;
 	int may;
 
 	switch (cmd) {
@@ -1532,6 +1532,7 @@ static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
 		return -EINVAL;
 	}
 
+	ssp = smack_of_shm(shp);
 	return smk_curacc(ssp, may);
 }
 
@@ -1616,7 +1617,7 @@ static int smack_sem_associate(struct sem_array *sma, int semflg)
  */
 static int smack_sem_semctl(struct sem_array *sma, int cmd)
 {
-	char *ssp = smack_of_sem(sma);
+	char *ssp;
 	int may;
 
 	switch (cmd) {
@@ -1645,6 +1646,7 @@ static int smack_sem_semctl(struct sem_array *sma, int cmd)
 		return -EINVAL;
 	}
 
+	ssp = smack_of_sem(sma);
 	return smk_curacc(ssp, may);
 }
 
@@ -1730,7 +1732,7 @@ static int smack_msg_queue_associate(struct msg_queue *msq, int msqflg)
  */
 static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 {
-	char *msp = smack_of_msq(msq);
+	char *msp;
 	int may;
 
 	switch (cmd) {
@@ -1752,6 +1754,7 @@ static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 		return -EINVAL;
 	}
 
+	msp = smack_of_msq(msq);
 	return smk_curacc(msp, may);
 }
 
Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

