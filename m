Return-Path: <linux-kernel-owner+w=401wt.eu-S1761742AbYDVCd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761742AbYDVCd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 22:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbYDVCdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 22:33:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:60555 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbYDVCdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 22:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=KyKwDZRdy/aR+6O9JI7ciSOKsZlsjGmlTK5TsXAn/+BHnTGlUkD9Xozh8eSYaLbdeZ8Xma/a7aSbDgvBOFuPs4hcCNxPF1MMI1Srky9jZM+UgTx7YSxpyYoCD3pffIJ2zvRNd+H8SGKGVR3h6PQtX5DsDOgy+/HBbRwWLXvFgho=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: do not pass size into kmem_free, it's unused
Date: Tue, 22 Apr 2008 04:33:03 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804212151.02241.vda.linux@googlemail.com> <20080422012819.GT108924158@sgi.com>
In-Reply-To: <20080422012819.GT108924158@sgi.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_g5UDICqRKTnXRiP"
Message-Id: <200804220433.04030.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_g5UDICqRKTnXRiP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

> Patches are welcome - I'd be over the moon if any of the known 4k
> stack advocates sent a stack reduction patch for XFS, but it seems
> that actually trying to fix the problems is much harder than
> resending a one line patch every few months....

kmem_free() function takes (ptr, size) arguments but doesn't
actually use second one.

This patch removes size argument from all callsites.

Code size difference on 32-bit x86:

# size */fs/xfs/xfs.o
   text    data     bss     dec     hex filename
 391271    2748    1708  395727   609cf linux-2.6-xfs0-TEST/fs/xfs/xfs.o
 390739    2748    1708  395195   607bb linux-2.6-xfs1-TEST/fs/xfs/xfs.o

Compile-tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_g5UDICqRKTnXRiP
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="xfs-kmem_free-remove_unused_param.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs-kmem_free-remove_unused_param.patch"

--- linux-2.6-xfs0/fs/xfs/linux-2.6/kmem.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/linux-2.6/kmem.c	Tue Apr 22 04:13:50 2008
@@ -90,7 +90,7 @@
 }
 
 void
-kmem_free(void *ptr, size_t size)
+kmem_free(void *ptr)
 {
 	if (!is_vmalloc_addr(ptr)) {
 		kfree(ptr);
@@ -110,7 +110,7 @@
 		if (new)
 			memcpy(new, ptr,
 				((oldsize < newsize) ? oldsize : newsize));
-		kmem_free(ptr, oldsize);
+		kmem_free(ptr);
 	}
 	return new;
 }
--- linux-2.6-xfs0/fs/xfs/linux-2.6/kmem.h	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/linux-2.6/kmem.h	Tue Apr 22 04:12:09 2008
@@ -58,7 +58,7 @@
 extern void *kmem_zalloc(size_t, unsigned int __nocast);
 extern void *kmem_zalloc_greedy(size_t *, size_t, size_t, unsigned int __nocast);
 extern void *kmem_realloc(void *, size_t, size_t, unsigned int __nocast);
-extern void  kmem_free(void *, size_t);
+extern void  kmem_free(void *);
 
 /*
  * Zone interfaces
--- linux-2.6-xfs0/fs/xfs/linux-2.6/xfs_buf.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/linux-2.6/xfs_buf.c	Tue Apr 22 04:14:06 2008
@@ -310,8 +310,7 @@
 	xfs_buf_t	*bp)
 {
 	if (bp->b_pages != bp->b_page_array) {
-		kmem_free(bp->b_pages,
-			  bp->b_page_count * sizeof(struct page *));
+		kmem_free(bp->b_pages);
 	}
 }
 
@@ -1382,7 +1381,7 @@
 xfs_free_bufhash(
 	xfs_buftarg_t		*btp)
 {
-	kmem_free(btp->bt_hash, (1<<btp->bt_hashshift) * sizeof(xfs_bufhash_t));
+	kmem_free(btp->bt_hash);
 	btp->bt_hash = NULL;
 }
 
@@ -1428,7 +1427,7 @@
 	xfs_unregister_buftarg(btp);
 	kthread_stop(btp->bt_task);
 
-	kmem_free(btp, sizeof(*btp));
+	kmem_free(btp);
 }
 
 STATIC int
@@ -1559,7 +1558,7 @@
 	return btp;
 
 error:
-	kmem_free(btp, sizeof(*btp));
+	kmem_free(btp);
 	return NULL;
 }
 
--- linux-2.6-xfs0/fs/xfs/linux-2.6/xfs_super.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/linux-2.6/xfs_super.c	Tue Apr 22 04:14:19 2008
@@ -1074,7 +1074,7 @@
 			list_del(&work->w_list);
 			if (work == &mp->m_sync_work)
 				continue;
-			kmem_free(work, sizeof(struct bhv_vfs_sync_work));
+			kmem_free(work);
 		}
 	}
 
@@ -1222,7 +1222,7 @@
 	error = xfs_parseargs(mp, options, args, 1);
 	if (!error)
 		error = xfs_mntupdate(mp, flags, args);
-	kmem_free(args, sizeof(*args));
+	kmem_free(args);
 	return -error;
 }
 
@@ -1370,7 +1370,7 @@
 
 	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
 
-	kmem_free(args, sizeof(*args));
+	kmem_free(args);
 	return 0;
 
 fail_vnrele:
@@ -1385,7 +1385,7 @@
 	xfs_unmount(mp, 0, NULL);
 
 fail_vfsop:
-	kmem_free(args, sizeof(*args));
+	kmem_free(args);
 	return -error;
 }
 
--- linux-2.6-xfs0/fs/xfs/quota/xfs_dquot_item.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/quota/xfs_dquot_item.c	Tue Apr 22 04:13:40 2008
@@ -566,8 +566,8 @@
 	 * xfs_trans_delete_ail() drops the AIL lock.
 	 */
 	xfs_trans_delete_ail(qfs->qql_item.li_mountp, (xfs_log_item_t *)qfs);
-	kmem_free(qfs, sizeof(xfs_qoff_logitem_t));
-	kmem_free(qfe, sizeof(xfs_qoff_logitem_t));
+	kmem_free(qfs);
+	kmem_free(qfe);
 	return (xfs_lsn_t)-1;
 }
 
--- linux-2.6-xfs0/fs/xfs/quota/xfs_qm.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/quota/xfs_qm.c	Tue Apr 22 04:13:03 2008
@@ -192,8 +192,8 @@
 		xfs_qm_list_destroy(&(xqm->qm_usr_dqhtable[i]));
 		xfs_qm_list_destroy(&(xqm->qm_grp_dqhtable[i]));
 	}
-	kmem_free(xqm->qm_usr_dqhtable, hsize * sizeof(xfs_dqhash_t));
-	kmem_free(xqm->qm_grp_dqhtable, hsize * sizeof(xfs_dqhash_t));
+	kmem_free(xqm->qm_usr_dqhtable);
+	kmem_free(xqm->qm_grp_dqhtable);
 	xqm->qm_usr_dqhtable = NULL;
 	xqm->qm_grp_dqhtable = NULL;
 	xqm->qm_dqhashmask = 0;
@@ -201,7 +201,7 @@
 #ifdef DEBUG
 	mutex_destroy(&qcheck_lock);
 #endif
-	kmem_free(xqm, sizeof(xfs_qm_t));
+	kmem_free(xqm);
 }
 
 /*
@@ -1133,7 +1133,7 @@
 	 * and change the superblock accordingly.
 	 */
 	if ((error = xfs_qm_init_quotainos(mp))) {
-		kmem_free(qinf, sizeof(xfs_quotainfo_t));
+		kmem_free(qinf);
 		mp->m_quotainfo = NULL;
 		return error;
 	}
@@ -1247,7 +1247,7 @@
 		qi->qi_gquotaip = NULL;
 	}
 	mutex_destroy(&qi->qi_quotaofflock);
-	kmem_free(qi, sizeof(xfs_quotainfo_t));
+	kmem_free(qi);
 	mp->m_quotainfo = NULL;
 }
 
@@ -1624,7 +1624,7 @@
 			break;
 	} while (nmaps > 0);
 
-	kmem_free(map, XFS_DQITER_MAP_SIZE * sizeof(*map));
+	kmem_free(map);
 
 	return error;
 }
--- linux-2.6-xfs0/fs/xfs/quota/xfs_qm_syscalls.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/quota/xfs_qm_syscalls.c	Tue Apr 22 04:13:32 2008
@@ -1447,14 +1447,14 @@
 		for (d = (xfs_dqtest_t *) h1->qh_next; d != NULL; ) {
 			xfs_dqtest_cmp(d);
 			e = (xfs_dqtest_t *) d->HL_NEXT;
-			kmem_free(d, sizeof(xfs_dqtest_t));
+			kmem_free(d);
 			d = e;
 		}
 		h1 = &qmtest_gdqtab[i];
 		for (d = (xfs_dqtest_t *) h1->qh_next; d != NULL; ) {
 			xfs_dqtest_cmp(d);
 			e = (xfs_dqtest_t *) d->HL_NEXT;
-			kmem_free(d, sizeof(xfs_dqtest_t));
+			kmem_free(d);
 			d = e;
 		}
 	}
@@ -1465,8 +1465,8 @@
 	} else {
 		cmn_err(CE_DEBUG, "******** quotacheck successful! ********");
 	}
-	kmem_free(qmtest_udqtab, qmtest_hashmask * sizeof(xfs_dqhash_t));
-	kmem_free(qmtest_gdqtab, qmtest_hashmask * sizeof(xfs_dqhash_t));
+	kmem_free(qmtest_udqtab);
+	kmem_free(qmtest_gdqtab);
 	mutex_unlock(&qcheck_lock);
 	return (qmtest_nfails);
 }
--- linux-2.6-xfs0/fs/xfs/support/ktrace.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/support/ktrace.c	Tue Apr 22 04:13:47 2008
@@ -85,7 +85,7 @@
 		if (sleep & KM_SLEEP)
 			panic("ktrace_alloc: NULL memory on KM_SLEEP request!");
 
-		kmem_free(ktp, sizeof(*ktp));
+		kmem_free(ktp);
 
 		return NULL;
 	}
@@ -120,7 +120,7 @@
 	} else {
 		entries_size = (int)(ktp->kt_nentries * sizeof(ktrace_entry_t));
 
-		kmem_free(ktp->kt_entries, entries_size);
+		kmem_free(ktp->kt_entries);
 	}
 
 	kmem_zone_free(ktrace_hdr_zone, ktp);
--- linux-2.6-xfs0/fs/xfs/xfs_attr_leaf.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_attr_leaf.c	Tue Apr 22 04:16:04 2008
@@ -555,7 +555,7 @@
 out:
 	if(bp)
 		xfs_da_buf_done(bp);
-	kmem_free(tmpbuffer, size);
+	kmem_free(tmpbuffer);
 	return(error);
 }
 
@@ -676,7 +676,7 @@
 					     XFS_ERRLEVEL_LOW,
 					     context->dp->i_mount, sfe);
 			xfs_attr_trace_l_c("sf corrupted", context);
-			kmem_free(sbuf, sbsize);
+			kmem_free(sbuf);
 			return XFS_ERROR(EFSCORRUPTED);
 		}
 		if (!xfs_attr_namesp_match_overrides(context->flags, sfe->flags)) {
@@ -717,7 +717,7 @@
 		}
 	}
 	if (i == nsbuf) {
-		kmem_free(sbuf, sbsize);
+		kmem_free(sbuf);
 		xfs_attr_trace_l_c("blk end", context);
 		return(0);
 	}
@@ -747,7 +747,7 @@
 		cursor->offset++;
 	}
 
-	kmem_free(sbuf, sbsize);
+	kmem_free(sbuf);
 	xfs_attr_trace_l_c("sf E-O-F", context);
 	return(0);
 }
@@ -873,7 +873,7 @@
 	error = 0;
 
 out:
-	kmem_free(tmpbuffer, XFS_LBSIZE(dp->i_mount));
+	kmem_free(tmpbuffer);
 	return(error);
 }
 
@@ -1271,7 +1271,7 @@
 				be16_to_cpu(hdr_s->count), mp);
 	xfs_da_log_buf(trans, bp, 0, XFS_LBSIZE(mp) - 1);
 
-	kmem_free(tmpbuffer, XFS_LBSIZE(mp));
+	kmem_free(tmpbuffer);
 }
 
 /*
@@ -1921,7 +1921,7 @@
 				be16_to_cpu(drop_hdr->count), mp);
 		}
 		memcpy((char *)save_leaf, (char *)tmp_leaf, state->blocksize);
-		kmem_free(tmpbuffer, state->blocksize);
+		kmem_free(tmpbuffer);
 	}
 
 	xfs_da_log_buf(state->args->trans, save_blk->bp, 0,
@@ -2451,7 +2451,7 @@
 						(int)name_rmt->namelen,
 						valuelen,
 						(char*)args.value);
-				kmem_free(args.value, valuelen);
+				kmem_free(args.value);
 			}
 			else {
 				retval = context->put_listent(context,
@@ -2954,7 +2954,7 @@
 			error = tmp;	/* save only the 1st errno */
 	}
 
-	kmem_free((xfs_caddr_t)list, size);
+	kmem_free((xfs_caddr_t)list);
 	return(error);
 }
 
--- linux-2.6-xfs0/fs/xfs/xfs_bmap.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_bmap.c	Tue Apr 22 04:16:25 2008
@@ -5965,7 +5965,7 @@
 	xfs_iunlock_map_shared(ip, lock);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
-	kmem_free(map, subnex * sizeof(*map));
+	kmem_free(map);
 
 	return error;
 }
--- linux-2.6-xfs0/fs/xfs/xfs_buf_item.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_buf_item.c	Tue Apr 22 04:15:04 2008
@@ -884,9 +884,9 @@
 	}
 
 #ifdef XFS_TRANS_DEBUG
-	kmem_free(bip->bli_orig, XFS_BUF_COUNT(bp));
+	kmem_free(bip->bli_orig);
 	bip->bli_orig = NULL;
-	kmem_free(bip->bli_logged, XFS_BUF_COUNT(bp) / NBBY);
+	kmem_free(bip->bli_logged);
 	bip->bli_logged = NULL;
 #endif /* XFS_TRANS_DEBUG */
 
@@ -1133,9 +1133,9 @@
 	xfs_trans_delete_ail(mp, (xfs_log_item_t *)bip);
 
 #ifdef XFS_TRANS_DEBUG
-	kmem_free(bip->bli_orig, XFS_BUF_COUNT(bp));
+	kmem_free(bip->bli_orig);
 	bip->bli_orig = NULL;
-	kmem_free(bip->bli_logged, XFS_BUF_COUNT(bp) / NBBY);
+	kmem_free(bip->bli_logged);
 	bip->bli_logged = NULL;
 #endif /* XFS_TRANS_DEBUG */
 
--- linux-2.6-xfs0/fs/xfs/xfs_da_btree.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_da_btree.c	Tue Apr 22 04:21:21 2008
@@ -1598,7 +1598,7 @@
 					args->firstblock, args->total,
 					&mapp[mapi], &nmap, args->flist,
 					NULL))) {
-				kmem_free(mapp, sizeof(*mapp) * count);
+				kmem_free(mapp);
 				return error;
 			}
 			if (nmap < 1)
@@ -1620,11 +1620,11 @@
 	    mapp[mapi - 1].br_startoff + mapp[mapi - 1].br_blockcount !=
 	    bno + count) {
 		if (mapp != &map)
-			kmem_free(mapp, sizeof(*mapp) * count);
+			kmem_free(mapp);
 		return XFS_ERROR(ENOSPC);
 	}
 	if (mapp != &map)
-		kmem_free(mapp, sizeof(*mapp) * count);
+		kmem_free(mapp);
 	*new_blkno = (xfs_dablk_t)bno;
 	return 0;
 }
@@ -2090,10 +2090,10 @@
 		}
 	}
 	if (bplist) {
-		kmem_free(bplist, sizeof(*bplist) * nmap);
+		kmem_free(bplist);
 	}
 	if (mapp != &map) {
-		kmem_free(mapp, sizeof(*mapp) * nfsb);
+		kmem_free(mapp);
 	}
 	if (bpp)
 		*bpp = rbp;
@@ -2102,11 +2102,11 @@
 	if (bplist) {
 		for (i = 0; i < nbplist; i++)
 			xfs_trans_brelse(trans, bplist[i]);
-		kmem_free(bplist, sizeof(*bplist) * nmap);
+		kmem_free(bplist);
 	}
 exit0:
 	if (mapp != &map)
-		kmem_free(mapp, sizeof(*mapp) * nfsb);
+		kmem_free(mapp);
 	if (bpp)
 		*bpp = NULL;
 	return error;
@@ -2315,7 +2315,7 @@
 	if (dabuf->dirty)
 		xfs_da_buf_clean(dabuf);
 	if (dabuf->nbuf > 1)
-		kmem_free(dabuf->data, BBTOB(dabuf->bbcount));
+		kmem_free(dabuf->data);
 #ifdef XFS_DABUF_DEBUG
 	{
 		spin_lock(&xfs_dabuf_global_lock);
@@ -2332,7 +2332,7 @@
 	if (dabuf->nbuf == 1)
 		kmem_zone_free(xfs_dabuf_zone, dabuf);
 	else
-		kmem_free(dabuf, XFS_DA_BUF_SIZE(dabuf->nbuf));
+		kmem_free(dabuf);
 }
 
 /*
@@ -2403,7 +2403,7 @@
 	for (i = 0; i < nbuf; i++)
 		xfs_trans_brelse(tp, bplist[i]);
 	if (bplist != &bp)
-		kmem_free(bplist, nbuf * sizeof(*bplist));
+		kmem_free(bplist);
 }
 
 /*
@@ -2429,7 +2429,7 @@
 	for (i = 0; i < nbuf; i++)
 		xfs_trans_binval(tp, bplist[i]);
 	if (bplist != &bp)
-		kmem_free(bplist, nbuf * sizeof(*bplist));
+		kmem_free(bplist);
 }
 
 /*
--- linux-2.6-xfs0/fs/xfs/xfs_dfrag.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_dfrag.c	Tue Apr 22 04:15:27 2008
@@ -116,7 +116,7 @@
  out_put_file:
 	fput(file);
  out_free_sxp:
-	kmem_free(sxp, sizeof(xfs_swapext_t));
+	kmem_free(sxp);
  out:
 	return error;
 }
@@ -381,6 +381,6 @@
 		xfs_iunlock(tip, lock_flags);
 	}
 	if (tempifp != NULL)
-		kmem_free(tempifp, sizeof(xfs_ifork_t));
+		kmem_free(tempifp);
 	return error;
 }
--- linux-2.6-xfs0/fs/xfs/xfs_dir2.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_dir2.c	Tue Apr 22 04:16:39 2008
@@ -499,7 +499,7 @@
 					args->firstblock, args->total,
 					&mapp[mapi], &nmap, args->flist,
 					NULL))) {
-				kmem_free(mapp, sizeof(*mapp) * count);
+				kmem_free(mapp);
 				return error;
 			}
 			if (nmap < 1)
@@ -531,14 +531,14 @@
 	    mapp[mapi - 1].br_startoff + mapp[mapi - 1].br_blockcount !=
 	    bno + count) {
 		if (mapp != &map)
-			kmem_free(mapp, sizeof(*mapp) * count);
+			kmem_free(mapp);
 		return XFS_ERROR(ENOSPC);
 	}
 	/*
 	 * Done with the temporary mapping table.
 	 */
 	if (mapp != &map)
-		kmem_free(mapp, sizeof(*mapp) * count);
+		kmem_free(mapp);
 	*dbp = xfs_dir2_da_to_db(mp, (xfs_dablk_t)bno);
 	/*
 	 * Update file's size if this is the data space and it grew.
--- linux-2.6-xfs0/fs/xfs/xfs_dir2_block.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_dir2_block.c	Tue Apr 22 04:19:32 2008
@@ -1071,7 +1071,7 @@
 	 */
 	error = xfs_dir2_grow_inode(args, XFS_DIR2_DATA_SPACE, &blkno);
 	if (error) {
-		kmem_free(buf, buf_len);
+		kmem_free(buf);
 		return error;
 	}
 	/*
@@ -1079,7 +1079,7 @@
 	 */
 	error = xfs_dir2_data_init(args, blkno, &bp);
 	if (error) {
-		kmem_free(buf, buf_len);
+		kmem_free(buf);
 		return error;
 	}
 	block = bp->data;
@@ -1198,7 +1198,7 @@
 			sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 	}
 	/* Done with the temporary buffer */
-	kmem_free(buf, buf_len);
+	kmem_free(buf);
 	/*
 	 * Sort the leaf entries by hash value.
 	 */
--- linux-2.6-xfs0/fs/xfs/xfs_dir2_leaf.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_dir2_leaf.c	Tue Apr 22 04:18:27 2008
@@ -1110,7 +1110,7 @@
 		*offset = XFS_DIR2_MAX_DATAPTR;
 	else
 		*offset = xfs_dir2_byte_to_dataptr(mp, curoff);
-	kmem_free(map, map_size * sizeof(*map));
+	kmem_free(map);
 	if (bp)
 		xfs_da_brelse(NULL, bp);
 	return error;
--- linux-2.6-xfs0/fs/xfs/xfs_dir2_sf.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_dir2_sf.c	Tue Apr 22 04:19:21 2008
@@ -255,7 +255,7 @@
 	xfs_dir2_sf_check(args);
 out:
 	xfs_trans_log_inode(args->trans, dp, logflags);
-	kmem_free(block, mp->m_dirblksize);
+	kmem_free(block);
 	return error;
 }
 
@@ -512,7 +512,7 @@
 		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 		memcpy(sfep, oldsfep, old_isize - nbytes);
 	}
-	kmem_free(buf, old_isize);
+	kmem_free(buf);
 	dp->i_d.di_size = new_isize;
 	xfs_dir2_sf_check(args);
 }
@@ -1174,7 +1174,7 @@
 	/*
 	 * Clean up the inode.
 	 */
-	kmem_free(buf, oldsize);
+	kmem_free(buf);
 	dp->i_d.di_size = newsize;
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 }
@@ -1251,7 +1251,7 @@
 	/*
 	 * Clean up the inode.
 	 */
-	kmem_free(buf, oldsize);
+	kmem_free(buf);
 	dp->i_d.di_size = newsize;
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 }
--- linux-2.6-xfs0/fs/xfs/xfs_error.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_error.c	Tue Apr 22 04:14:29 2008
@@ -150,8 +150,7 @@
 				xfs_etest[i]);
 			xfs_etest[i] = 0;
 			xfs_etest_fsid[i] = 0LL;
-			kmem_free(xfs_etest_fsname[i],
-				  strlen(xfs_etest_fsname[i]) + 1);
+			kmem_free(xfs_etest_fsname[i]);
 			xfs_etest_fsname[i] = NULL;
 		}
 	}
@@ -175,7 +174,7 @@
 		newfmt = kmem_alloc(len, KM_SLEEP);
 		sprintf(newfmt, "Filesystem \"%s\": %s", mp->m_fsname, fmt);
 		icmn_err(level, newfmt, ap);
-		kmem_free(newfmt, len);
+		kmem_free(newfmt);
 	} else {
 		icmn_err(level, fmt, ap);
 	}
--- linux-2.6-xfs0/fs/xfs/xfs_extfree_item.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_extfree_item.c	Tue Apr 22 04:15:19 2008
@@ -41,8 +41,7 @@
 	int nexts = efip->efi_format.efi_nextents;
 
 	if (nexts > XFS_EFI_MAX_FAST_EXTENTS) {
-		kmem_free(efip, sizeof(xfs_efi_log_item_t) +
-				(nexts - 1) * sizeof(xfs_extent_t));
+		kmem_free(efip);
 	} else {
 		kmem_zone_free(xfs_efi_zone, efip);
 	}
@@ -374,8 +373,7 @@
 	int nexts = efdp->efd_format.efd_nextents;
 
 	if (nexts > XFS_EFD_MAX_FAST_EXTENTS) {
-		kmem_free(efdp, sizeof(xfs_efd_log_item_t) +
-				(nexts - 1) * sizeof(xfs_extent_t));
+		kmem_free(efdp);
 	} else {
 		kmem_zone_free(xfs_efd_zone, efdp);
 	}
--- linux-2.6-xfs0/fs/xfs/xfs_inode.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_inode.c	Tue Apr 22 04:17:46 2008
@@ -2337,7 +2337,7 @@
 		xfs_trans_binval(tp, bp);
 	}
 
-	kmem_free(ip_found, ninodes * sizeof(xfs_inode_t *));
+	kmem_free(ip_found);
 	xfs_put_perag(mp, pag);
 }
 
@@ -2549,7 +2549,7 @@
 						     (int)new_size);
 		memcpy(np, op, new_max * (uint)sizeof(xfs_dfsbno_t));
 	}
-	kmem_free(ifp->if_broot, ifp->if_broot_bytes);
+	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
 	ASSERT(ifp->if_broot_bytes <=
@@ -2593,7 +2593,7 @@
 
 	if (new_size == 0) {
 		if (ifp->if_u1.if_data != ifp->if_u2.if_inline_data) {
-			kmem_free(ifp->if_u1.if_data, ifp->if_real_bytes);
+			kmem_free(ifp->if_u1.if_data);
 		}
 		ifp->if_u1.if_data = NULL;
 		real_size = 0;
@@ -2608,7 +2608,7 @@
 			ASSERT(ifp->if_real_bytes != 0);
 			memcpy(ifp->if_u2.if_inline_data, ifp->if_u1.if_data,
 			      new_size);
-			kmem_free(ifp->if_u1.if_data, ifp->if_real_bytes);
+			kmem_free(ifp->if_u1.if_data);
 			ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
 		}
 		real_size = 0;
@@ -2698,7 +2698,7 @@
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (ifp->if_broot != NULL) {
-		kmem_free(ifp->if_broot, ifp->if_broot_bytes);
+		kmem_free(ifp->if_broot);
 		ifp->if_broot = NULL;
 	}
 
@@ -2712,7 +2712,7 @@
 		if ((ifp->if_u1.if_data != ifp->if_u2.if_inline_data) &&
 		    (ifp->if_u1.if_data != NULL)) {
 			ASSERT(ifp->if_real_bytes != 0);
-			kmem_free(ifp->if_u1.if_data, ifp->if_real_bytes);
+			kmem_free(ifp->if_u1.if_data);
 			ifp->if_u1.if_data = NULL;
 			ifp->if_real_bytes = 0;
 		}
@@ -3861,7 +3861,7 @@
 			erp = xfs_iext_irec_new(ifp, erp_idx);
 		}
 		memmove(&erp->er_extbuf[i], nex2_ep, byte_diff);
-		kmem_free(nex2_ep, byte_diff);
+		kmem_free(nex2_ep);
 		erp->er_extcount += nex2;
 		xfs_iext_irec_update_extoffs(ifp, erp_idx + 1, nex2);
 	}
@@ -4137,7 +4137,7 @@
 	 */
 	memcpy(ifp->if_u2.if_inline_ext, ifp->if_u1.if_extents,
 		nextents * sizeof(xfs_bmbt_rec_t));
-	kmem_free(ifp->if_u1.if_extents, ifp->if_real_bytes);
+	kmem_free(ifp->if_u1.if_extents);
 	ifp->if_u1.if_extents = ifp->if_u2.if_inline_ext;
 	ifp->if_real_bytes = 0;
 }
@@ -4211,7 +4211,7 @@
 	ASSERT(ifp->if_real_bytes == XFS_IEXT_BUFSZ);
 
 	ep = ifp->if_u1.if_ext_irec->er_extbuf;
-	kmem_free(ifp->if_u1.if_ext_irec, sizeof(xfs_ext_irec_t));
+	kmem_free(ifp->if_u1.if_ext_irec);
 	ifp->if_flags &= ~XFS_IFEXTIREC;
 	ifp->if_u1.if_extents = ep;
 	ifp->if_bytes = size;
@@ -4237,7 +4237,7 @@
 		}
 		ifp->if_flags &= ~XFS_IFEXTIREC;
 	} else if (ifp->if_real_bytes) {
-		kmem_free(ifp->if_u1.if_extents, ifp->if_real_bytes);
+		kmem_free(ifp->if_u1.if_extents);
 	} else if (ifp->if_bytes) {
 		memset(ifp->if_u2.if_inline_ext, 0, XFS_INLINE_EXTS *
 			sizeof(xfs_bmbt_rec_t));
@@ -4508,7 +4508,7 @@
 	if (erp->er_extbuf) {
 		xfs_iext_irec_update_extoffs(ifp, erp_idx + 1,
 			-erp->er_extcount);
-		kmem_free(erp->er_extbuf, XFS_IEXT_BUFSZ);
+		kmem_free(erp->er_extbuf);
 	}
 	/* Compact extent records */
 	erp = ifp->if_u1.if_ext_irec;
@@ -4526,8 +4526,7 @@
 		xfs_iext_realloc_indirect(ifp,
 			nlists * sizeof(xfs_ext_irec_t));
 	} else {
-		kmem_free(ifp->if_u1.if_ext_irec,
-			sizeof(xfs_ext_irec_t));
+		kmem_free(ifp->if_u1.if_ext_irec);
 	}
 	ifp->if_real_bytes = nlists * XFS_IEXT_BUFSZ;
 }
@@ -4596,7 +4595,7 @@
 			 * so er_extoffs don't get modified in
 			 * xfs_iext_irec_remove.
 			 */
-			kmem_free(erp_next->er_extbuf, XFS_IEXT_BUFSZ);
+			kmem_free(erp_next->er_extbuf);
 			erp_next->er_extbuf = NULL;
 			xfs_iext_irec_remove(ifp, erp_idx + 1);
 			nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
@@ -4639,8 +4638,7 @@
 			 * so er_extoffs don't get modified in
 			 * xfs_iext_irec_remove.
 			 */
-			kmem_free(erp_next->er_extbuf,
-				erp_next->er_extcount * sizeof(xfs_bmbt_rec_t));
+			kmem_free(erp_next->er_extbuf);
 			erp_next->er_extbuf = NULL;
 			xfs_iext_irec_remove(ifp, erp_idx + 1);
 			erp = &ifp->if_u1.if_ext_irec[erp_idx];
--- linux-2.6-xfs0/fs/xfs/xfs_inode_item.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_inode_item.c	Tue Apr 22 04:16:19 2008
@@ -685,7 +685,7 @@
 		ASSERT(ip->i_d.di_nextents > 0);
 		ASSERT(iip->ili_format.ilf_fields & XFS_ILOG_DEXT);
 		ASSERT(ip->i_df.if_bytes > 0);
-		kmem_free(iip->ili_extents_buf, ip->i_df.if_bytes);
+		kmem_free(iip->ili_extents_buf);
 		iip->ili_extents_buf = NULL;
 	}
 	if (iip->ili_aextents_buf != NULL) {
@@ -693,7 +693,7 @@
 		ASSERT(ip->i_d.di_anextents > 0);
 		ASSERT(iip->ili_format.ilf_fields & XFS_ILOG_AEXT);
 		ASSERT(ip->i_afp->if_bytes > 0);
-		kmem_free(iip->ili_aextents_buf, ip->i_afp->if_bytes);
+		kmem_free(iip->ili_aextents_buf);
 		iip->ili_aextents_buf = NULL;
 	}
 
@@ -951,8 +951,7 @@
 {
 #ifdef XFS_TRANS_DEBUG
 	if (ip->i_itemp->ili_root_size != 0) {
-		kmem_free(ip->i_itemp->ili_orig_root,
-			  ip->i_itemp->ili_root_size);
+		kmem_free(ip->i_itemp->ili_orig_root);
 	}
 #endif
 	kmem_zone_free(xfs_ili_zone, ip->i_itemp);
--- linux-2.6-xfs0/fs/xfs/xfs_itable.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_itable.c	Tue Apr 22 04:19:05 2008
@@ -265,7 +265,7 @@
 		*ubused = error;
 
  out_free:
-	kmem_free(buf, sizeof(*buf));
+	kmem_free(buf);
 	return error;
 }
 
@@ -715,7 +715,7 @@
 	/*
 	 * Done, we're either out of filesystem or space to put the data.
 	 */
-	kmem_free(irbuf, irbsize);
+	kmem_free(irbuf);
 	*ubcountp = ubelem;
 	/*
 	 * Found some inodes, return them now and return the error next time.
@@ -921,7 +921,7 @@
 		}
 		*lastino = XFS_AGINO_TO_INO(mp, agno, agino);
 	}
-	kmem_free(buffer, bcount * sizeof(*buffer));
+	kmem_free(buffer);
 	if (cur)
 		xfs_btree_del_cursor(cur, (error ? XFS_BTREE_ERROR :
 					   XFS_BTREE_NOERROR));
--- linux-2.6-xfs0/fs/xfs/xfs_log.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_log.c	Tue Apr 22 04:16:49 2008
@@ -1552,7 +1552,7 @@
 		}
 #endif
 		next_iclog = iclog->ic_next;
-		kmem_free(iclog, sizeof(xlog_in_core_t));
+		kmem_free(iclog);
 		iclog = next_iclog;
 	}
 	freesema(&log->l_flushsema);
@@ -1571,7 +1571,7 @@
 		tic = log->l_unmount_free;
 		while (tic) {
 			next_tic = tic->t_next;
-			kmem_free(tic, PAGE_SIZE);
+			kmem_free(tic);
 			tic = next_tic;
 		}
 	}
@@ -1585,7 +1585,7 @@
 	}
 #endif
 	log->l_mp->m_log = NULL;
-	kmem_free(log, sizeof(xlog_t));
+	kmem_free(log);
 }	/* xlog_dealloc_log */
 
 /*
--- linux-2.6-xfs0/fs/xfs/xfs_log_recover.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_log_recover.c	Tue Apr 22 04:20:46 2008
@@ -1709,8 +1709,7 @@
 					} else {
 						prevp->bc_next = bcp->bc_next;
 					}
-					kmem_free(bcp,
-						  sizeof(xfs_buf_cancel_t));
+					kmem_free(bcp);
 				}
 			}
 			return 1;
@@ -2511,7 +2510,7 @@
 
 error:
 	if (need_free)
-		kmem_free(in_f, sizeof(*in_f));
+		kmem_free(in_f);
 	return XFS_ERROR(error);
 }
 
@@ -2822,16 +2821,14 @@
 		item = item->ri_next;
 		 /* Free the regions in the item. */
 		for (i = 0; i < free_item->ri_cnt; i++) {
-			kmem_free(free_item->ri_buf[i].i_addr,
-				  free_item->ri_buf[i].i_len);
+			kmem_free(free_item->ri_buf[i].i_addr);
 		}
 		/* Free the item itself */
-		kmem_free(free_item->ri_buf,
-			  (free_item->ri_total * sizeof(xfs_log_iovec_t)));
-		kmem_free(free_item, sizeof(xlog_recover_item_t));
+		kmem_free(free_item->ri_buf);
+		kmem_free(free_item);
 	} while (first_item != item);
 	/* Free the transaction recover structure */
-	kmem_free(trans, sizeof(xlog_recover_t));
+	kmem_free(trans);
 }
 
 STATIC int
@@ -3747,8 +3744,7 @@
 	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
 				      XLOG_RECOVER_PASS1);
 	if (error != 0) {
-		kmem_free(log->l_buf_cancel_table,
-			  XLOG_BC_TABLE_SIZE * sizeof(xfs_buf_cancel_t*));
+		kmem_free(log->l_buf_cancel_table);
 		log->l_buf_cancel_table = NULL;
 		return error;
 	}
@@ -3767,8 +3763,7 @@
 	}
 #endif	/* DEBUG */
 
-	kmem_free(log->l_buf_cancel_table,
-		  XLOG_BC_TABLE_SIZE * sizeof(xfs_buf_cancel_t*));
+	kmem_free(log->l_buf_cancel_table);
 	log->l_buf_cancel_table = NULL;
 
 	return error;
--- linux-2.6-xfs0/fs/xfs/xfs_mount.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_mount.c	Tue Apr 22 04:20:08 2008
@@ -158,11 +158,8 @@
 
 		for (agno = 0; agno < mp->m_maxagi; agno++)
 			if (mp->m_perag[agno].pagb_list)
-				kmem_free(mp->m_perag[agno].pagb_list,
-						sizeof(xfs_perag_busy_t) *
-							XFS_PAGB_NUM_SLOTS);
-		kmem_free(mp->m_perag,
-			  sizeof(xfs_perag_t) * mp->m_sb.sb_agcount);
+				kmem_free(mp->m_perag[agno].pagb_list);
+		kmem_free(mp->m_perag);
 	}
 
 	spinlock_destroy(&mp->m_ail_lock);
@@ -173,11 +170,11 @@
 		XFS_QM_DONE(mp);
 
 	if (mp->m_fsname != NULL)
-		kmem_free(mp->m_fsname, mp->m_fsname_len);
+		kmem_free(mp->m_fsname);
 	if (mp->m_rtname != NULL)
-		kmem_free(mp->m_rtname, strlen(mp->m_rtname) + 1);
+		kmem_free(mp->m_rtname);
 	if (mp->m_logname != NULL)
-		kmem_free(mp->m_logname, strlen(mp->m_logname) + 1);
+		kmem_free(mp->m_logname);
 
 	xfs_icsb_destroy_counters(mp);
 }
@@ -1219,9 +1216,8 @@
  error2:
 	for (agno = 0; agno < sbp->sb_agcount; agno++)
 		if (mp->m_perag[agno].pagb_list)
-			kmem_free(mp->m_perag[agno].pagb_list,
-			  sizeof(xfs_perag_busy_t) * XFS_PAGB_NUM_SLOTS);
-	kmem_free(mp->m_perag, sbp->sb_agcount * sizeof(xfs_perag_t));
+			kmem_free(mp->m_perag[agno].pagb_list);
+	kmem_free(mp->m_perag);
 	mp->m_perag = NULL;
 	/* FALLTHROUGH */
  error1:
--- linux-2.6-xfs0/fs/xfs/xfs_mru_cache.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_mru_cache.c	Tue Apr 22 04:18:08 2008
@@ -382,9 +382,9 @@
 
 exit:
 	if (err && mru && mru->lists)
-		kmem_free(mru->lists, mru->grp_count * sizeof(*mru->lists));
+		kmem_free(mru->lists);
 	if (err && mru)
-		kmem_free(mru, sizeof(*mru));
+		kmem_free(mru);
 
 	return err;
 }
@@ -424,8 +424,8 @@
 
 	xfs_mru_cache_flush(mru);
 
-	kmem_free(mru->lists, mru->grp_count * sizeof(*mru->lists));
-	kmem_free(mru, sizeof(*mru));
+	kmem_free(mru->lists);
+	kmem_free(mru);
 }
 
 /*
--- linux-2.6-xfs0/fs/xfs/xfs_rtalloc.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_rtalloc.c	Tue Apr 22 04:18:12 2008
@@ -2053,7 +2053,7 @@
 	/*
 	 * Free the fake mp structure.
 	 */
-	kmem_free(nmp, sizeof(*nmp));
+	kmem_free(nmp);
 
 	return error;
 }
--- linux-2.6-xfs0/fs/xfs/xfs_trans.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_trans.c	Tue Apr 22 04:18:22 2008
@@ -889,7 +889,7 @@
 
 	tp->t_commit_lsn = commit_lsn;
 	if (nvec > XFS_TRANS_LOGVEC_COUNT) {
-		kmem_free(log_vector, nvec * sizeof(xfs_log_iovec_t));
+		kmem_free(log_vector);
 	}
 
 	/*
@@ -1265,7 +1265,7 @@
 		ASSERT(!XFS_LIC_ARE_ALL_FREE(licp));
 		xfs_trans_chunk_committed(licp, tp->t_lsn, abortflag);
 		next_licp = licp->lic_next;
-		kmem_free(licp, sizeof(xfs_log_item_chunk_t));
+		kmem_free(licp);
 		licp = next_licp;
 	}
 
--- linux-2.6-xfs0/fs/xfs/xfs_trans_inode.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_trans_inode.c	Tue Apr 22 04:12:18 2008
@@ -291,7 +291,7 @@
 	iip = ip->i_itemp;
 	if (iip->ili_root_size != 0) {
 		ASSERT(iip->ili_orig_root != NULL);
-		kmem_free(iip->ili_orig_root, iip->ili_root_size);
+		kmem_free(iip->ili_orig_root);
 		iip->ili_root_size = 0;
 		iip->ili_orig_root = NULL;
 	}
--- linux-2.6-xfs0/fs/xfs/xfs_trans_item.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_trans_item.c	Tue Apr 22 04:14:45 2008
@@ -161,7 +161,7 @@
 			licpp = &((*licpp)->lic_next);
 		}
 		*licpp = licp->lic_next;
-		kmem_free(licp, sizeof(xfs_log_item_chunk_t));
+		kmem_free(licp);
 		tp->t_items_free -= XFS_LIC_NUM_SLOTS;
 	}
 }
@@ -314,7 +314,7 @@
 		ASSERT(!XFS_LIC_ARE_ALL_FREE(licp));
 		(void) xfs_trans_unlock_chunk(licp, 1, abort, NULLCOMMITLSN);
 		next_licp = licp->lic_next;
-		kmem_free(licp, sizeof(xfs_log_item_chunk_t));
+		kmem_free(licp);
 		licp = next_licp;
 	}
 
@@ -363,7 +363,7 @@
 		next_licp = licp->lic_next;
 		if (XFS_LIC_ARE_ALL_FREE(licp)) {
 			*licpp = next_licp;
-			kmem_free(licp, sizeof(xfs_log_item_chunk_t));
+			kmem_free(licp);
 			freed -= XFS_LIC_NUM_SLOTS;
 		} else {
 			licpp = &(licp->lic_next);
@@ -530,7 +530,7 @@
 	lbcp = tp->t_busy.lbc_next;
 	while (lbcp != NULL) {
 		lbcq = lbcp->lbc_next;
-		kmem_free(lbcp, sizeof(xfs_log_busy_chunk_t));
+		kmem_free(lbcp);
 		lbcp = lbcq;
 	}
 
--- linux-2.6-xfs0/fs/xfs/xfs_vfsops.c	Tue Apr 22 03:56:05 2008
+++ linux-2.6-xfs1/fs/xfs/xfs_vfsops.c	Tue Apr 22 04:18:53 2008
@@ -641,7 +641,7 @@
 		xfs_unmountfs(mp, credp);
 		xfs_qmops_put(mp);
 		xfs_dmops_put(mp);
-		kmem_free(mp, sizeof(xfs_mount_t));
+		kmem_free(mp);
 	}
 
 	return XFS_ERROR(error);
@@ -1054,7 +1054,7 @@
 
 		if (XFS_FORCED_SHUTDOWN(mp) && !(flags & SYNC_CLOSE)) {
 			XFS_MOUNT_IUNLOCK(mp);
-			kmem_free(ipointer, sizeof(xfs_iptr_t));
+			kmem_free(ipointer);
 			return 0;
 		}
 
@@ -1200,7 +1200,7 @@
 			}
 			XFS_MOUNT_IUNLOCK(mp);
 			ASSERT(ipointer_in == B_FALSE);
-			kmem_free(ipointer, sizeof(xfs_iptr_t));
+			kmem_free(ipointer);
 			return XFS_ERROR(error);
 		}
 
@@ -1230,7 +1230,7 @@
 
 	ASSERT(ipointer_in == B_FALSE);
 
-	kmem_free(ipointer, sizeof(xfs_iptr_t));
+	kmem_free(ipointer);
 	return XFS_ERROR(last_error);
 }
 

--Boundary-00=_g5UDICqRKTnXRiP--
